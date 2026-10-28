import SwiftUI

struct PlayerBar: View {
    @Environment(LibraryStore.self) private var store

    var body: some View {
        @Bindable var store = store
        HStack(spacing: 22) {
            currentSong
                .frame(minWidth: 160, idealWidth: 190, maxWidth: 235, alignment: .leading)
            Spacer(minLength: 0)
            transport
                .frame(minWidth: 260, idealWidth: 340, maxWidth: 420)
            Spacer(minLength: 0)
            HStack(spacing: 10) {
                Image(systemName: "speaker.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Slider(value: $store.volume, in: 0...1)
                    .frame(minWidth: 55, idealWidth: 85, maxWidth: 100)
                    .accessibilityLabel("音量")
                Image(systemName: "speaker.wave.3.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                control("待播清单", symbol: "text.line.first.and.arrowtriangle.forward",
                        active: store.showQueue) {
                    store.showQueue.toggle()
                }
            }
            .frame(minWidth: 150, idealWidth: 170, maxWidth: 195, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 11)
        .frame(minHeight: 78)
        .background(.bar)
    }

    private var currentSong: some View {
        HStack(spacing: 10) {
            Button {
                store.navigate(to: .nowPlaying)
            } label: {
                HStack(spacing: 10) {
                    AlbumArtwork(album: store.currentAlbum)
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(store.currentSong.title)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        Text(store.currentSong.artist)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("打开正在播放")
            .accessibilityLabel("正在播放，\(store.currentSong.title)，\(store.currentSong.artist)")

            Spacer(minLength: 0)
            control(store.favoriteIDs.contains(store.currentSong.id) ? "取消喜欢" : "喜欢",
                    symbol: store.favoriteIDs.contains(store.currentSong.id) ? "heart.fill" : "heart",
                    active: store.favoriteIDs.contains(store.currentSong.id)) {
                store.toggleFavorite(store.currentSong)
            }
        }
    }

    private var transport: some View {
        @Bindable var store = store
        return VStack(spacing: 4) {
            HStack(spacing: 10) {
                control("随机播放", symbol: "shuffle", active: store.shuffle) {
                    store.shuffle.toggle()
                }
                control("上一首", symbol: "backward.end.fill") { store.previous() }
                Button(action: store.togglePlayback) {
                    Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 32, height: 28)
                }
                .buttonStyle(.plain)
                .help(store.isPlaying ? "暂停" : "播放")
                .accessibilityLabel(store.isPlaying ? "暂停" : "播放")
                control("下一首", symbol: "forward.end.fill") { store.next() }
                control("循环播放", symbol: "repeat", active: store.repeatEnabled) {
                    store.repeatEnabled.toggle()
                }
            }
            HStack(spacing: 7) {
                Text(timeLabel(store.position))
                    .frame(width: 31, alignment: .trailing)
                Slider(value: $store.position, in: 0...Double(store.currentSong.seconds))
                    .accessibilityLabel("播放进度")
                    .accessibilityValue("\(timeLabel(store.position))，总时长 \(store.currentSong.duration)")
                Text("-\(timeLabel(Double(store.currentSong.seconds) - store.position))")
                    .frame(width: 35, alignment: .leading)
            }
            .font(.system(size: 10))
            .foregroundStyle(.secondary)
            .monospacedDigit()
        }
    }

    private func control(_ title: String, symbol: String, active: Bool = false,
                         action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(active ? Color.accentColor : Color.primary)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
        .help(title)
        .accessibilityLabel(title)
    }

    private func timeLabel(_ time: Double) -> String {
        let seconds = max(0, Int(time))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}
