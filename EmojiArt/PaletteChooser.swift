//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by vphom on 10/6/20.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    var body: some View {
        HStack {
            Stepper(onIncrement: {}, onDecrement: {}, label: {EmptyView()})
            Text("Palette Name")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
