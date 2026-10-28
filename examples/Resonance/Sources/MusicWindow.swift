import SwiftUI

struct MusicWindow: View {
    @Environment(LibraryStore.self) private var store
    @Environment(\.openSettings) private var openSettings
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    private var selection: Binding<MusicPage?> {
        Binding(get: { store.page }, set: { if let page = $0 { store.navigate(to: page) } })
    }

    var body: some View {
        @Bindable var store = store
        VStack(spacing: 0) {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                sidebar
                    .navigationSplitViewColumnWidth(min: 200, ideal: 224, max: 280)
            } detail: {
                pageContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(nsColor: .textBackgroundColor))
                    .navigationTitle(windowTitle)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigation) {
                            Button(action: store.goBack) { Image(systemName: "chevron.left") }
                                .disabled(!store.canGoBack).help("返回（⌘[）")
                            Button(action: store.goForward) { Image(systemName: "chevron.right") }
                                .disabled(!store.canGoForward).help("前进（⌘]）")
                        }
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button { store.showQueue.toggle() } label: {
                                Image(systemName: "list.bullet")
                            }
                            .help("显示待播清单").accessibilityLabel("显示待播清单")
                            SettingsLink { Image(systemName: "gearshape") }.help("设置（⌘,）")
                        }
                    }
                    .searchable(text: $store.searchText, placement: .toolbar, prompt: "搜索资料库")
            }
            .inspector(isPresented: $store.showQueue) {
                QueueInspector().inspectorColumnWidth(min: 240, ideal: 270, max: 320)
            }
            Divider()
            PlayerBar()
        }
        .frame(minWidth: 880, minHeight: 640)
        .task {
            if PreviewConfiguration.page == "settings" { openSettings() }
        }
        .onChange(of: store.searchText) { _, query in
            if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               store.page == .listen || store.page == .nowPlaying {
                store.navigate(to: .songs)
            }
        }
    }

    private var sidebar: some View {
        List(selection: selection) {
            HStack(spacing: 9) {
                Image(systemName: "waveform.circle.fill")
                    .font(.title2).foregroundStyle(Color.accentColor)
                Text("余音").font(.title2.weight(.semibold))
            }
            .padding(.vertical, 16)
            .listRowSeparator(.hidden)
            Section("浏览") {
                Label("现在就听", systemImage: "play.circle").tag(MusicPage.listen)
            }
            Section("资料库") {
                Label("专辑", systemImage: "square.stack").tag(MusicPage.albums)
                Label("歌曲", systemImage: "music.note").tag(MusicPage.songs)
            }
            Section("你的歌单") {
                Label("晚风与耳机", systemImage: "moon.stars").tag(MusicPage.evening)
                Label("专注时刻", systemImage: "sparkles").tag(MusicPage.focus)
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 7) {
                Image(systemName: "opticaldisc")
                Text("\(store.albums.count) 张专辑 · \(store.songs.count) 首歌曲")
            }
            .font(.subheadline).foregroundStyle(.secondary)
            .padding(.bottom, 20)
        }
    }

    private var windowTitle: String {
        if case .album(let id) = store.page {
            return store.albums.first { $0.id == id }?.title ?? "专辑"
        }
        return store.page.title
    }

    @ViewBuilder private var pageContent: some View {
        switch store.page {
        case .listen: ListenView()
        case .albums: AlbumsView()
        case .songs:
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .firstTextBaseline) {
                    Text("全部歌曲").font(.title2.weight(.semibold))
                    Spacer()
                    Text("\(store.filtered(store.songs).count) 首歌曲")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24).padding(.top, 24)
                TrackTable(songs: store.filtered(store.songs))
            }
        case .evening: PlaylistView(playlist: store.playlists[0])
        case .focus: PlaylistView(playlist: store.playlists[1])
        case .album(let id):
            if let album = store.albums.first(where: { $0.id == id }) { AlbumDetailView(album: album) }
        case .nowPlaying: NowPlayingView()
        }
    }
}
