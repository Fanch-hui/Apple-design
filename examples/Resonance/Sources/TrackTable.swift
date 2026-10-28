import SwiftUI

private struct TrackRow: Identifiable {
    let song: Song
    let albumTitle: String
    var id: String { song.id }
    var title: String { song.title }
    var artist: String { song.artist }
    var duration: Int { song.seconds }
}

struct TrackTable: View {
    @Environment(LibraryStore.self) private var store
    @State private var selection: Set<String> = []
    @State private var sortOrder: [KeyPathComparator<TrackRow>] = []
    let songs: [Song]

    private var rows: [TrackRow] {
        let rows = songs.map { TrackRow(song: $0, albumTitle: store.album(for: $0).title) }
        return sortOrder.isEmpty ? rows : rows.sorted(using: sortOrder)
    }

    var body: some View {
        Table(rows, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("歌曲", value: \.title) { row in
                songCell(row.song)
            }
            .width(min: 210, ideal: 280)
            TableColumn("艺人", value: \.artist) { row in
                Text(row.artist).lineLimit(1)
            }
            .width(min: 100, ideal: 140)
            TableColumn("专辑", value: \.albumTitle) { row in
                Text(row.albumTitle).lineLimit(1)
            }
            .width(min: 120, ideal: 160)
            TableColumn("时长", sortUsing: KeyPathComparator(\TrackRow.duration)) { row in
                Text(row.song.duration).monospacedDigit().foregroundStyle(.secondary)
            }
            .width(min: 54, ideal: 70, max: 80)
        }
        .contextMenu(forSelectionType: String.self) { ids in
            if let song = selectedSong(in: ids) {
                Button("播放") { store.play(song, in: songs) }
                Button("接下来播放") { store.playNext(song) }
                Button(store.favoriteIDs.contains(song.id) ? "取消喜欢" : "喜欢") {
                    store.toggleFavorite(song)
                }
            }
        } primaryAction: { ids in
            if let song = selectedSong(in: ids) { store.play(song, in: songs) }
        }
        .overlay {
            if songs.isEmpty {
                ContentUnavailableView {
                    Label("没有找到歌曲", systemImage: "magnifyingglass")
                } description: {
                    Text("试试其他歌曲名称或艺人。")
                }
            }
        }
    }

    private func songCell(_ song: Song) -> some View {
        HStack(spacing: 10) {
            AlbumArtwork(album: store.album(for: song))
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(song.title).lineLimit(1)
            if store.favoriteIDs.contains(song.id) {
                Image(systemName: "heart.fill")
                    .font(.caption2).foregroundStyle(.secondary)
                    .accessibilityLabel("已喜欢")
            }
            if store.currentSongID == song.id && store.isPlaying {
                Image(systemName: "waveform")
                    .font(.caption).foregroundStyle(Color.accentColor)
                    .accessibilityLabel("正在播放")
            }
        }
        .padding(.vertical, 3)
    }

    private func selectedSong(in ids: Set<String>) -> Song? {
        rows.first { ids.contains($0.id) }?.song
    }
}
