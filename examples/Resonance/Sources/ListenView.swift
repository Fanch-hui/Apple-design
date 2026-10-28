import SwiftUI

struct ListenView: View {
    @Environment(LibraryStore.self) private var store

    private var featured: Album { store.albums[0] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                heading
                featuredAlbum
                recommendedAlbums
                recentSongs
            }
            .frame(maxWidth: 1050, alignment: .leading)
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(nsColor: .textBackgroundColor))
    }

    private var heading: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("听见今天的好心情").font(.system(size: 22, weight: .semibold))
            Text("留一点时间，给音乐。")
                .foregroundStyle(.secondary)
        }
    }

    private var featuredAlbum: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 24) {
                featuredArtwork(size: 190)
                featuredDescription
            }
            VStack(alignment: .leading, spacing: 18) {
                featuredArtwork(size: 160)
                featuredDescription
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(nsColor: .controlBackgroundColor),
                    in: RoundedRectangle(cornerRadius: 12))
    }

    private func featuredArtwork(size: CGFloat) -> some View {
        AlbumArtwork(album: featured)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var featuredDescription: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("今日精选", systemImage: "sparkles")
                .font(.caption.weight(.medium)).foregroundStyle(.secondary)
            Text(featured.title).font(.system(size: 22, weight: .semibold))
            Text("\(featured.artist)  ·  \(featured.genre)  ·  \(String(featured.year))")
                .font(.subheadline).foregroundStyle(.secondary)
            Text(featured.description)
                .font(.body).foregroundStyle(.secondary)
                .lineLimit(3).fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 10) {
                Button {
                    let songs = store.songs(in: featured)
                    if let first = songs.first { store.play(first, in: songs) }
                } label: {
                    Label("播放专辑", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                Button("查看专辑") { store.navigate(to: .album(featured.id)) }
            }
            .padding(.top, 3)
        }
        .frame(maxWidth: 430, alignment: .leading)
    }

    private var recommendedAlbums: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("为你精选").font(.headline)
                Spacer()
                Button("查看全部") { store.navigate(to: .albums) }
                    .buttonStyle(.link)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170, maximum: 220), spacing: 16)],
                      alignment: .leading, spacing: 18) {
                ForEach(Array(store.albums.prefix(4))) { album in
                    AlbumTile(album: album)
                }
            }
        }
    }

    private var recentSongs: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("最近播放").font(.headline)
                Spacer()
                Button("全部歌曲") { store.navigate(to: .songs) }
                    .buttonStyle(.link)
            }
            VStack(spacing: 0) {
                ForEach(Array(store.songs.prefix(4))) { song in
                    Button {
                        store.play(song, in: Array(store.songs.prefix(4)))
                    } label: {
                        HStack(spacing: 10) {
                            AlbumArtwork(album: store.album(for: song))
                                .frame(width: 32, height: 32)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(song.title).foregroundStyle(.primary).lineLimit(1)
                                Text(song.artist).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                            }
                            Spacer(minLength: 12)
                            Text(song.duration).monospacedDigit().foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 7)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .help("播放 \(song.title)")
                    if song.id != store.songs.prefix(4).last?.id { Divider().padding(.leading, 42) }
                }
            }
        }
    }
}
