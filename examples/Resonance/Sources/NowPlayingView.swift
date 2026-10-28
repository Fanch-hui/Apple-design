import SwiftUI

struct NowPlayingView: View {
    @Environment(LibraryStore.self) private var store

    var body: some View {
        ScrollView {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 52) {
                    albumColumn.frame(width: 300)
                    listeningColumn.frame(width: 270, alignment: .leading)
                }
                VStack(alignment: .leading, spacing: 32) {
                    albumColumn.frame(maxWidth: 300)
                    listeningColumn.frame(maxWidth: 430, alignment: .leading)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 36)
            .frame(maxWidth: .infinity, minHeight: 510)
        }
    }

    private var albumColumn: some View {
        VStack(alignment: .leading, spacing: 18) {
            AlbumArtwork(album: store.currentAlbum)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityLabel("\(store.currentAlbum.title)专辑封面")
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(store.currentSong.title)
                        .font(.title2.weight(.semibold))
                        .lineLimit(2)
                    Text(store.currentSong.artist)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Button {
                    store.toggleFavorite(store.currentSong)
                } label: {
                    Image(systemName: store.favoriteIDs.contains(store.currentSong.id) ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(store.favoriteIDs.contains(store.currentSong.id) ? Color.accentColor : Color.secondary)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .help(store.favoriteIDs.contains(store.currentSong.id) ? "取消喜欢" : "喜欢")
                .accessibilityLabel(store.favoriteIDs.contains(store.currentSong.id) ? "取消喜欢" : "喜欢")
            }
            Button {
                store.navigate(to: .album(store.currentAlbum.id))
            } label: {
                HStack(spacing: 5) {
                    Text(store.currentAlbum.title)
                    Image(systemName: "chevron.right").font(.caption2.weight(.semibold))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("查看专辑 \(store.currentAlbum.title)")
        }
    }

    private var listeningColumn: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("此刻，留给自己")
                .font(.title3.weight(.semibold))
            Rectangle()
                .fill(Color.secondary.opacity(0.18))
                .frame(width: 28, height: 1)
            Text("就让这一刻慢一点\n把喧闹留在门外\n让旋律带你，回到此刻")
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(.primary)
                .lineSpacing(10)
                .fixedSize(horizontal: false, vertical: true)
            Text("正在聆听 \(store.currentSong.title) · \(store.currentSong.artist)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
