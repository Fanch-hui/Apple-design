import SwiftUI

@main
struct MotionApp: App {
    @State private var store = ActivityStore()
    @AppStorage("appearance") private var appearance = "system"

    var body: some Scene {
        WindowGroup {
            MotionTabs()
                .environment(store)
                .environment(\.locale, Locale(identifier: "zh_CN"))
                .preferredColorScheme(appearance == "system" ? nil : appearance == "dark" ? .dark : .light)
        }
    }
}

private struct MotionTabs: View {
    private enum Tab { case today, history, trends }
    @State private var selection = Tab.today
    @State private var showingSession = false
    @State private var showingSettings = false

    var body: some View {
        TabView(selection: $selection) {
            TodayView(onStart: { showingSession = true },
                      onHistory: { selection = .history },
                      onSettings: { showingSettings = true })
                .tabItem { Label("今日", systemImage: "sun.max") }.tag(Tab.today)
            HistoryView()
                .tabItem { Label("记录", systemImage: "list.bullet.rectangle") }.tag(Tab.history)
            TrendsView()
                .tabItem { Label("趋势", systemImage: "chart.xyaxis.line") }.tag(Tab.trends)
        }
        .fullScreenCover(isPresented: $showingSession) { SessionView() }
        .sheet(isPresented: $showingSettings) { SettingsView() }
        .task {
            switch PreviewScenario.current {
            case .history, .detail, .add: selection = .history
            case .trends: selection = .trends
            case .session: showingSession = true
            case .settings: showingSettings = true
            case .today, nil: break
            }
        }
    }
}
