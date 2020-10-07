//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by vphom on 10/6/20.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

// define the layout for the popup window
struct PaletteChooser: View {
    
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPatte: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {self.chosenPatte = self.document.palette(after:self.chosenPatte)}, onDecrement: {self.chosenPatte = self.document.palette(before: self.chosenPatte)},
                label: {EmptyView()})
            Text(self.document.paletteNames[self.chosenPatte] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture { // when user tap on keyboard icon
                    self.showPaletteEditor = true
                }
                
                // the popover is a helper view separate from the main view or using sheet instead
                .sheet(isPresented:$showPaletteEditor){
                    PaletteEditor(chosenPalette:self.$chosenPatte,isShowing:$showPaletteEditor)
                        .environmentObject(self.document) // set the environment for the popover
                        .frame(minWidth:300,minHeight:500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

// the palette editor layout it is separate from the main view
// should use the environment object variable to share info between main and its helpers
struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    @State private var paletteName: String = ""
    @Binding var chosenPalette: String
    @State private var emojisToAdd: String = ""
    @Binding var isShowing: Bool
    
    var body: some View{
        VStack(spacing: 0){
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action:{self.isShowing = false},label:{Text("Done")}).padding()
                }
            
            }
            
            Divider()
            Form {
                Section{
                    TextField("Palette Name",text: $paletteName, onEditingChanged: {
                        began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    }).padding()
                    TextField("Add Emoji",text: $emojisToAdd, onEditingChanged: {
                        began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = ""
                        }
                    }).padding()
                }
                Section(header: Text("Remove Emoji")) {
                    VStack {
                        Grid(chosenPalette.map {String ($0)}, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: self.fontSize))
                                .onTapGesture {
                                        self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                        }
                        .frame(height: self.height)
                        
                    }
                }
            }
            
        }
        .onAppear{self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""}
    }
    
    // MARK - Drawing constants
    var height: CGFloat{
        CGFloat((chosenPalette.count - 1) / 6 ) * 70 + 70
    }
    let fontSize: CGFloat = 40
}

//struct PaletteChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteChooser(document: <#T##EmojiArtDocument#>(), chosenPatte: Binding.constant(""))
//    }
//}
