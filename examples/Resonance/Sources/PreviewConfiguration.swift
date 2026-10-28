import SwiftUI

enum PreviewConfiguration {
    static var page: String {
        #if DEBUG
        ProcessInfo.processInfo.environment["RESONANCE_PREVIEW_PAGE"] ?? ""
        #else
        ""
        #endif
    }
    static var appearance: String? {
        #if DEBUG
        ProcessInfo.processInfo.environment["RESONANCE_PREVIEW_APPEARANCE"]
        #else
        nil
        #endif
    }

    @MainActor static func configure(_ store: LibraryStore) {
        switch page {
        case "albums": store.navigate(to: .albums)
        case "songs": store.navigate(to: .songs)
        case "evening": store.navigate(to: .evening)
        case "focus": store.navigate(to: .focus)
        case "album": store.navigate(to: .album("blue"))
        case "playing": store.navigate(to: .nowPlaying); store.isPlaying = true
        case "queue": store.showQueue = true
        default: break
        }
    }
}
