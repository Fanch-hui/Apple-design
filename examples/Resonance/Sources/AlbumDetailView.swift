import SwiftUI

struct AlbumDetailView: View {
    @Environment(LibraryStore.self) private var store
    let album: Album

    private var albumSongs: [Song] { store.filtered(store.songs(in: album)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text("歌曲").font(.headline)
                    Spacer()
                    Text("\(albumSongs.count) 首歌曲")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                TrackTable(songs: albumSongs)
                    .frame(minHeight: 240, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: 1050, maxHeight: .infinity, alignment: .topLeading)
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .textBackgroundColor))
    }

    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 24) {
                artwork(size: 190)
                information
            }
            HStack(alignment: .center, spacing: 16) {
                artwork(size: 132)
                information
            }
        }
    }

    private func artwork(size: CGFloat) -> some View {
        AlbumArtwork(album: album)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var information: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("专辑").font(.caption.weight(.medium)).foregroundStyle(.secondary)
            Text(album.title).font(.system(size: 22, weight: .semibold)).lineLimit(2)
            Text(album.artist).font(.body.weight(.medium))
            Text("\(album.genre)  ·  \(String(album.year))")
                .font(.subheadline).foregroundStyle(.secondary)
            Text(album.description).font(.body).foregroundStyle(.secondary)
                .lineLimit(2).fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 10) {
                Button {
                    let songs = store.songs(in: album)
                    if let first = songs.first { store.play(first, in: songs) }
                } label: {
                    Label("播放", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    let songs = store.songs(in: album).shuffled()
                    if let first = songs.first {
                        store.shuffle = true
                        store.play(first, in: songs)
                    }
                } label: {
                    Label("随机播放", systemImage: "shuffle")
                }
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: 450, alignment: .leading)
    }
}
