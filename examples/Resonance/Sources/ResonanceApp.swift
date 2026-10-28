import SwiftUI

@main
struct ResonanceApp: App {
    @State private var store: LibraryStore
    @AppStorage("resonance.appearance") private var appearance = "system"

    init() {
        let library = LibraryStore()
        PreviewConfiguration.configure(library)
        _store = State(initialValue: library)
    }

    private var colorScheme: ColorScheme? {
        switch PreviewConfiguration.appearance ?? appearance {
        case "dark": .dark
        case "light": .light
        default: nil
        }
    }

    var body: some Scene {
        WindowGroup("余音") {
            MusicWindow()
                .environment(store)
                .environment(\.locale, Locale(identifier: "zh_CN"))
                .tint(Color(nsColor: .controlAccentColor))
                .preferredColorScheme(colorScheme)
        }
        .defaultSize(width: 1180, height: 760)
        .windowToolbarStyle(.unified)
        .commands {
            SidebarCommands()
            CommandMenu("播放") {
                Button(store.isPlaying ? "暂停" : "播放") { store.togglePlayback() }
                    .keyboardShortcut(.space, modifiers: [])
                Button("下一首") { store.next() }.keyboardShortcut(.rightArrow, modifiers: .command)
                Button("上一首") { store.previous() }.keyboardShortcut(.leftArrow, modifiers: .command)
                Divider()
                Button("喜欢这首歌") { store.toggleFavorite(store.currentSong) }
                    .keyboardShortcut("l", modifiers: [.command, .shift])
                Button("正在播放") { store.navigate(to: .nowPlaying) }
                Button("显示待播清单") { store.showQueue.toggle() }
            }
            CommandGroup(after: .sidebar) {
                Button("返回") { store.goBack() }
                    .keyboardShortcut("[", modifiers: .command).disabled(!store.canGoBack)
                Button("前进") { store.goForward() }
                    .keyboardShortcut("]", modifiers: .command).disabled(!store.canGoForward)
            }
        }
        Settings {
            SettingsView()
                .environment(store)
                .environment(\.locale, Locale(identifier: "zh_CN"))
                .preferredColorScheme(colorScheme)
        }
    }
}
