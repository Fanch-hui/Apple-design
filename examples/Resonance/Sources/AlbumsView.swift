import SwiftUI

struct AlbumsView: View {
    @Environment(LibraryStore.self) private var store

    private var filteredAlbums: [Album] {
        let query = store.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return store.albums.filter {
            query.isEmpty || "\($0.title) \($0.englishTitle) \($0.artist)"
                .localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    Text("你的音乐收藏").font(.system(size: 22, weight: .semibold))
                    Spacer()
                    Text("\(filteredAlbums.count) 张专辑")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                if filteredAlbums.isEmpty {
                    ContentUnavailableView {
                        Label("没有找到专辑", systemImage: "magnifyingglass")
                    } description: {
                        Text("试试其他专辑名称或艺人。")
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 145, maximum: 190), spacing: 20)],
                              alignment: .leading, spacing: 24) {
                        ForEach(filteredAlbums) { album in
                            AlbumTile(album: album)
                        }
                    }
                }
            }
            .frame(maxWidth: 1050, alignment: .leading)
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

struct AlbumTile: View {
    @Environment(LibraryStore.self) private var store
    let album: Album

    var body: some View {
        Button {
            store.navigate(to: .album(album.id))
        } label: {
            VStack(alignment: .leading, spacing: 7) {
                AlbumArtwork(album: album)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                Text(album.title).font(.body.weight(.medium))
                    .foregroundStyle(.primary).lineLimit(1)
                Text(album.artist).font(.caption)
                    .foregroundStyle(.secondary).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help("查看专辑 \(album.title)")
        .accessibilityLabel("专辑，\(album.title)，\(album.artist)")
    }
}
