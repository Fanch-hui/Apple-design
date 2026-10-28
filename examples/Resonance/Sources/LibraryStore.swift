import SwiftUI
import Observation

enum MusicPage: Hashable {
    case listen, albums, songs, evening, focus, album(String), nowPlaying

    var title: String {
        switch self {
        case .listen: "现在就听"
        case .albums: "专辑"
        case .songs: "歌曲"
        case .evening: "晚风与耳机"
        case .focus: "专注时刻"
        case .album: "专辑详情"
        case .nowPlaying: "正在播放"
        }
    }
}

struct Album: Identifiable, Hashable {
    let id: String
    let title: String
    let englishTitle: String
    let artist: String
    let year: Int
    let genre: String
    let artwork: Int
    let description: String
}

struct Song: Identifiable, Hashable {
    let id: String
    let title: String
    let artist: String
    let albumID: String
    let track: Int
    let seconds: Int
    var duration: String { String(format: "%d:%02d", seconds / 60, seconds % 60) }
}

struct MusicPlaylist: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let artwork: Int
    let songIDs: [String]
}

@MainActor @Observable
final class LibraryStore {
    let albums = SampleLibrary.albums
    let songs = SampleLibrary.songs
    let playlists = SampleLibrary.playlists
    private var history: [MusicPage] = [.listen]
    private var historyIndex = 0
    var searchText = ""
    var currentSongID = "blue-1"
    var isPlaying = false
    var position: Double = 73
    var volume: Double = 0.65
    var showQueue = false
    var shuffle = false
    var repeatEnabled = false
    var favoriteIDs: Set<String> = ["blue-1", "coast-2", "hills-1", "night-2"]
    var queueIDs = ["blue-1", "blue-2", "coast-1", "hills-2", "night-1", "sun-1"]

    var page: MusicPage { history[historyIndex] }
    var canGoBack: Bool { historyIndex > 0 }
    var canGoForward: Bool { historyIndex + 1 < history.count }
    var currentSong: Song { songs.first { $0.id == currentSongID } ?? songs[0] }
    var currentAlbum: Album { album(for: currentSong) }
    var queue: [Song] { queueIDs.compactMap { id in songs.first { $0.id == id } } }

    func album(for song: Song) -> Album {
        albums.first { $0.id == song.albumID } ?? albums[0]
    }

    func songs(in album: Album) -> [Song] { songs.filter { $0.albumID == album.id } }
    func songs(in playlist: MusicPlaylist) -> [Song] {
        playlist.songIDs.compactMap { id in songs.first { $0.id == id } }
    }
    func filtered(_ songs: [Song]) -> [Song] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return songs.filter { query.isEmpty || "\($0.title) \($0.artist) \(album(for: $0).title)".localizedCaseInsensitiveContains(query) }
    }
    func navigate(to page: MusicPage) {
        guard page != self.page else { return }
        history = Array(history.prefix(historyIndex + 1)) + [page]
        historyIndex = history.count - 1
    }
    func goBack() { if canGoBack { historyIndex -= 1 } }
    func goForward() { if canGoForward { historyIndex += 1 } }

    func play(_ song: Song, in collection: [Song]? = nil) {
        if let collection { queueIDs = collection.map(\.id) }
        if !queueIDs.contains(song.id) { queueIDs.append(song.id) }
        currentSongID = song.id
        position = 0
        isPlaying = true
    }
    func togglePlayback() { isPlaying.toggle() }
    func toggleFavorite(_ song: Song) {
        if favoriteIDs.contains(song.id) { favoriteIDs.remove(song.id) }
        else { favoriteIDs.insert(song.id) }
    }
    func next() {
        guard !queue.isEmpty else { return }
        let index = queue.firstIndex { $0.id == currentSongID } ?? 0
        let next = shuffle ? queue.randomElement()! : queue[(index + 1) % queue.count]
        play(next)
    }
    func previous() {
        guard !queue.isEmpty else { return }
        let index = queue.firstIndex { $0.id == currentSongID } ?? 0
        play(queue[(index - 1 + queue.count) % queue.count])
    }
    func playNext(_ song: Song) {
        queueIDs.removeAll { $0 == song.id }
        let index = queueIDs.firstIndex(of: currentSongID).map { $0 + 1 } ?? 0
        queueIDs.insert(song.id, at: index)
    }
}
