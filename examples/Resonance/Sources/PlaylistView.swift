import SwiftUI

struct PlaylistView: View {
    @Environment(LibraryStore.self) private var store
    let playlist: MusicPlaylist

    private var songs: [Song] { store.songs(in: playlist) }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 24) {
                CoverArtwork(index: playlist.artwork,
                             title: playlist.id == "evening" ? "EVENING\nSOUNDS" : "STAY\nFOCUSED", subtitle: "余音精选")
                    .frame(width: 178, height: 178)
                VStack(alignment: .leading, spacing: 12) {
                    Text("你的歌单").font(.subheadline).foregroundStyle(.secondary)
                    Text(playlist.title).font(.title.weight(.semibold))
                    Text(playlist.subtitle).font(.body).foregroundStyle(.secondary)
                    Text("\(songs.count) 首歌曲 · \(songs.reduce(0) { $0 + $1.seconds } / 60) 分钟")
                        .font(.subheadline).foregroundStyle(.secondary)
                    HStack(spacing: 10) {
                        Button {
                            if let first = songs.first { store.play(first, in: songs) }
                        } label: { Label("播放", systemImage: "play.fill") }
                            .buttonStyle(.borderedProminent)
                        Button {
                            if let first = songs.randomElement() {
                                store.shuffle = true
                                store.play(first, in: songs)
                            }
                        } label: { Label("随机播放", systemImage: "shuffle") }
                    }
                    .controlSize(.large).padding(.top, 4)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24).padding(.top, 24)
            TrackTable(songs: store.filtered(songs))
        }
    }
}
