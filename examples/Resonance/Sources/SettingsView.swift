import SwiftUI

struct SettingsView: View {
    @Environment(LibraryStore.self) private var store
    @AppStorage("resonance.appearance") private var appearance = "system"

    var body: some View {
        @Bindable var store = store
        Form {
            Section("外观") {
                Picker("显示模式", selection: $appearance) {
                    Text("跟随系统").tag("system")
                    Text("浅色").tag("light")
                    Text("深色").tag("dark")
                }
                .pickerStyle(.segmented)
            }
            Section("播放") {
                Picker("播放顺序", selection: $store.shuffle) {
                    Text("顺序播放").tag(false)
                    Text("随机播放").tag(true)
                }
                Toggle("单曲循环", isOn: $store.repeatEnabled)
                    .toggleStyle(.checkbox)
                LabeledContent("音量") {
                    HStack(spacing: 10) {
                        Image(systemName: "speaker.wave.1").foregroundStyle(.secondary)
                        Slider(value: $store.volume, in: 0...1).frame(width: 170)
                            .accessibilityLabel("音量")
                        Image(systemName: "speaker.wave.3").foregroundStyle(.secondary)
                    }
                }
            }
            Section("关于") {
                LabeledContent("余音", value: "1.0")
                Text("留一点时间，给音乐。")
                    .font(.body).foregroundStyle(.secondary)
                Text("界面体验版本。歌曲和封面为本地示例，播放控件用于预览交互。")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding(8)
        .frame(width: 560, height: 470)
    }
}
