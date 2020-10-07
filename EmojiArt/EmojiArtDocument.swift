//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import Combine

// the viewmodel

class EmojiArtDocument: ObservableObject, Hashable,Identifiable
{
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    let id: UUID
    func hash(into hasher: inout Hasher)  {
        hasher.combine(id)
    }
    
    static let palette: String = "⭐️⛈🍎🌏🥨⚾️"
    
    // @Published // workaround for property observer problem with property wrappers
    @Published private var emojiArt: EmojiArt
    
    private static let untitled = "EmojiArtDocument.Untitled"
        
    private var autosaveCancellable: AnyCancellable?

    // this let it call with nil, id, or none
    init(id: UUID? = nil) {
            self.id = id ?? UUID()
            let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
            // emojiArt may return nil on init use the default init
            emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
          
            // subscribe to emojiArt
            autosaveCancellable = $emojiArt.sink { emojiArt in
                print("\(emojiArt.json?.utf8 ?? "nil")")
                UserDefaults.standard.set(emojiArt.json,forKey: defaultsKey)
            }
            fetchBackgroundImageData()
    }
        
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }

    func setBackgroundURL(_ url: URL?)  {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
        
    }
    
    private var fetchImageCancellable: AnyCancellable?
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel() // cancel any pending request
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map {data, URLResponse in UIImage(data:data)}  // convert tuple into image
                .receive(on: DispatchQueue.main) // publish on the main thread
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self) // use the keypath
        }
        
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
