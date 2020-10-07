//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by vphom on 10/6/20.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    
    var body: some View {
        List {
            ForEach (store.documents){ document in
                Text(self.store.name(for: document))
            }
        }
    }
}

//struct EmojiArtDocumentChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentChooser()
//    }
//}
