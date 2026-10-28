import SwiftUI

struct HistoryView: View {
    private struct WorkoutDay: Identifiable {
        let date: Date
        let workouts: [Workout]
        var id: Date { date }
    }

    @Environment(ActivityStore.self) private var store
    @State private var searchText = ""
    @State private var selectedKind: WorkoutKind?
    @State private var showingAddWorkout = false
    @State private var path: [Workout] = []

    private var matchingWorkouts: [Workout] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return store.sortedWorkouts.filter { workout in
            let matchesKind = selectedKind == nil || workout.kind == selectedKind
            let matchesSearch = query.isEmpty || [workout.title, workout.kind.rawValue, workout.note]
                .contains { $0.localizedCaseInsensitiveContains(query) }
            return matchesKind && matchesSearch
        }
    }

    private var groupedWorkouts: [WorkoutDay] {
        Dictionary(grouping: matchingWorkouts) {
            Calendar.current.startOfDay(for: $0.date)
        }
        .map { WorkoutDay(date: $0.key, workouts: $0.value) }
        .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(groupedWorkouts) { group in
                    Section {
                        ForEach(group.workouts) { workout in
                            NavigationLink(value: workout) {
                                WorkoutRow(workout: workout)
                            }
                        }
                    } header: {
                        Text(sectionTitle(for: group.date))
                    }
                }
            }
            .listStyle(.insetGrouped)
            .overlay {
                if matchingWorkouts.isEmpty {
                    ContentUnavailableView {
                        Label("没有找到运动记录", systemImage: "magnifyingglass")
                    } description: {
                        Text("试试其他关键词或运动类型。")
                    } actions: {
                        Button("清除筛选") {
                            searchText = ""
                            selectedKind = nil
                        }
                    }
                }
            }
            .navigationTitle("记录")
            .searchable(text: $searchText, prompt: "搜索运动记录")
            .sheet(isPresented: $showingAddWorkout) { AddWorkoutView() }
            .navigationDestination(for: Workout.self) { workout in
                WorkoutDetailView(workout: workout)
            }
            .task {
                if PreviewScenario.current == .detail, path.isEmpty,
                   let workout = store.sortedWorkouts.first {
                    path = [workout]
                }
                if PreviewScenario.current == .add { showingAddWorkout = true }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加记录", systemImage: "plus") { showingAddWorkout = true }
                        .labelStyle(.iconOnly)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("运动类型", selection: $selectedKind) {
                            Text("全部运动").tag(WorkoutKind?.none)
                            ForEach(WorkoutKind.allCases) { kind in
                                Text(kind.rawValue).tag(Optional(kind))
                            }
                        }
                    } label: {
                        Label(selectedKind?.rawValue ?? "筛选", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("筛选运动类型")
                    .accessibilityValue(selectedKind?.rawValue ?? "全部运动")
                }
            }
        }
    }

    private func sectionTitle(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "今天" }
        if calendar.isDateInYesterday(date) { return "昨天" }

        let dateStyle = Date.FormatStyle.dateTime.month().day()
            .locale(Locale(identifier: "zh_CN"))
        if calendar.isDate(date, equalTo: .now, toGranularity: .year) {
            return date.formatted(dateStyle)
        }
        return date.formatted(dateStyle.year())
    }
}
