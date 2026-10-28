import SwiftUI

struct QueueInspector: View {
    @Environment(LibraryStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("待播清单").font(.headline)
                Spacer()
                Button {
                    store.showQueue = false
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 26, height: 26)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("关闭待播清单")
                .accessibilityLabel("关闭待播清单")
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 6)

            Text("\(store.queue.count) 首歌曲")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 14)

            if store.queue.isEmpty {
                ContentUnavailableView("暂无待播歌曲", systemImage: "music.note.list")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(store.queue) { song in
                            songRow(song)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
                }
            }
        }
        .frame(minWidth: 240, idealWidth: 270, maxWidth: 320, maxHeight: .infinity, alignment: .topLeading)
    }

    private func songRow(_ song: Song) -> some View {
        let selected = song.id == store.currentSongID
        return Button {
            store.play(song)
        } label: {
            HStack(spacing: 10) {
                AlbumArtwork(album: store.album(for: song))
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                VStack(alignment: .leading, spacing: 3) {
                    Text(song.title)
                        .font(.body.weight(selected ? .semibold : .regular))
                        .foregroundStyle(selected ? Color.accentColor : Color.primary)
                        .lineLimit(1)
                    Text(song.artist)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 4)
                if selected {
                    Image(systemName: store.isPlaying ? "speaker.wave.2.fill" : "pause.fill")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                        .accessibilityHidden(true)
                } else {
                    Text(song.duration)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
            .background(selected ? Color.accentColor.opacity(0.10) : Color.clear,
                        in: RoundedRectangle(cornerRadius: 7))
        }
        .buttonStyle(.plain)
        .help("播放 \(song.title)")
        .accessibilityLabel("\(song.title)，\(song.artist)，\(song.duration)")
        .accessibilityValue(selected ? "当前歌曲" : "")
        .contextMenu {
            Button("播放") { store.play(song) }
            Button("下一首播放") { store.playNext(song) }
                .disabled(selected)
        }
    }
}
