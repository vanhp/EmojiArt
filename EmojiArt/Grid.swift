//
//  Grid.swift
//  memorize
//
//  Created by vphom on 10/4/20.
//

import SwiftUI

// extension adapter
// to make the old style grid work with new with the use of keypath
extension Grid where Item: Identifiable, ID==Item.ID {
    // let the old style call the new style
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView){
        self.init(items,id: \Item.id, viewForItem: viewForItem)
    }
}


struct Grid<Item,ID,ItemView>: View where ID: Hashable,ItemView:View{
    private var items:[Item]
    private var viewForItem: (Item) -> ItemView
    private var id: KeyPath<Item,ID>
    
    init(_ items:[Item],id:KeyPath<Item,ID>,viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader{
            geometry in
            self.body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    private func body(for layout:GridLayout) -> some View {
        return ForEach(items, id:id){item in
            self.body(for: item, in: layout)
        }
    }
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(where: {item[keyPath: id] == $0[keyPath: id]})
        
        return Group {
            if index != nil {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
            }
        }
    }
}



//struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid([],GridItem)
//    }
//}
