import SwiftUI
import Observation

enum WorkoutKind: String, CaseIterable, Identifiable {
    case run = "跑步"
    case walk = "步行"
    case cycle = "骑行"
    case strength = "力量训练"

    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .run: "figure.run"
        case .walk: "figure.walk"
        case .cycle: "figure.outdoor.cycle"
        case .strength: "dumbbell"
        }
    }
    var color: Color {
        switch self {
        case .run: .accentColor
        case .walk: .teal
        case .cycle: .blue
        case .strength: .purple
        }
    }
    var hasDistance: Bool { self != .strength }
}

struct Workout: Identifiable, Hashable {
    var id = UUID()
    var kind: WorkoutKind
    var title: String
    var date: Date
    var durationMinutes: Int
    var distance: Double
    var energy: Int
    var note: String = ""

    var distanceText: String {
        distance > 0 ? distance.formatted(.number.precision(.fractionLength(2))) : "—"
    }
    var energyText: String { energy > 0 ? "\(energy)" : "—" }
    var durationText: String { "\(durationMinutes) 分钟" }
    var paceText: String {
        guard distance > 0 else { return "—" }
        let seconds = Int(Double(durationMinutes * 60) / distance)
        return String(format: "%d′%02d″", seconds / 60, seconds % 60)
    }
}

@MainActor @Observable
final class ActivityStore {
    var workouts: [Workout] = []
    var dailyGoal = 45

    init() {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: .now)
        func date(_ offset: Int, _ hour: Int) -> Date {
            calendar.date(byAdding: .hour, value: hour,
                          to: calendar.date(byAdding: .day, value: offset, to: day)!)!
        }
        workouts = [
            Workout(kind: .run, title: "江边晨跑", date: date(0, 7), durationMinutes: 38,
                    distance: 5.2, energy: 312, note: "迎着晨风跑完熟悉的路线，今天的状态很轻盈。"),
            Workout(kind: .strength, title: "全身力量", date: date(-1, 19), durationMinutes: 45,
                    distance: 0, energy: 260, note: "深蹲、俯卧撑和核心训练。循序渐进，保持自己的节奏。"),
            Workout(kind: .walk, title: "日落散步", date: date(-2, 17), durationMinutes: 32,
                    distance: 2.8, energy: 126, note: "忙碌之后，给自己一点放空的时间。"),
            Workout(kind: .run, title: "轻松跑 5 公里", date: date(-3, 7), durationMinutes: 36,
                    distance: 5, energy: 298),
            Workout(kind: .cycle, title: "周末绿道骑行", date: date(-5, 9), durationMinutes: 64,
                    distance: 18.6, energy: 486, note: "沿着绿道一路向前，发现了一家新的咖啡店。"),
            Workout(kind: .run, title: "公园慢跑", date: date(-7, 7), durationMinutes: 29,
                    distance: 4.1, energy: 245)
        ]
    }

    var sortedWorkouts: [Workout] { workouts.sorted { $0.date > $1.date } }
    var todayWorkouts: [Workout] { on(.now) }
    var recentDays: [Date] {
        let day = Calendar.current.startOfDay(for: .now)
        return (-6...0).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: day) }
    }
    var weekWorkouts: [Workout] {
        guard let first = recentDays.first else { return [] }
        return workouts.filter { $0.date >= first && $0.date <= .now }
    }
    var todayMinutes: Int { todayWorkouts.reduce(0) { $0 + $1.durationMinutes } }
    var todayDistance: Double { todayWorkouts.reduce(0) { $0 + $1.distance } }
    var todayEnergy: Int { todayWorkouts.reduce(0) { $0 + $1.energy } }
    var goalProgress: Double { min(Double(todayMinutes) / Double(dailyGoal), 1) }

    func on(_ date: Date) -> [Workout] {
        workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func add(_ workout: Workout) { workouts.insert(workout, at: 0) }
}
