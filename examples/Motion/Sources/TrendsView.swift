import SwiftUI
import Charts

struct TrendsView: View {
    @Environment(ActivityStore.self) private var store
    @State private var period = 7

    private var days: [Date] {
        let today = Calendar.current.startOfDay(for: .now)
        return (-(period - 1)...0).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }
    private var workouts: [Workout] {
        guard let start = days.first else { return [] }
        return store.workouts.filter { $0.date >= start && $0.date <= .now }
    }
    private var totalMinutes: Int { workouts.reduce(0) { $0 + $1.durationMinutes } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Picker("统计周期", selection: $period) {
                        Text("最近 7 天").tag(7)
                        Text("最近 30 天").tag(30)
                    }
                    .pickerStyle(.segmented)
                    summary
                    activityBreakdown
                    consistency
                }
                .padding(20).padding(.bottom, 24)
                .frame(maxWidth: 650).frame(maxWidth: .infinity)
            }
            .background(MotionStyle.background)
            .navigationTitle("趋势")
        }
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("把运动，变成日常。")
                .font(.title2.weight(.semibold))
            Text("累计运动时长").font(.subheadline).foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(totalMinutes, format: .number)
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                Text("分钟").font(.body).foregroundStyle(.secondary)
            }
            Chart(days, id: \.self) { date in
                BarMark(x: .value("日期", date, unit: .day),
                        y: .value("分钟", store.on(date).reduce(0) { $0 + $1.durationMinutes }))
                    .foregroundStyle(Color.accentColor.gradient).cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: period == 7 ? 1 : 7)) { _ in
                    AxisValueLabel(format: .dateTime.day())
                }
            }
            .chartYAxis { AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) }
            .frame(height: 180)
            Divider()
            ViewThatFits(in: .horizontal) {
                HStack {
                    MetricLabel(value: "\(workouts.count)", unit: "次", caption: "运动次数")
                    Spacer()
                    MetricLabel(value: workouts.reduce(0) { $0 + $1.distance }.formatted(.number.precision(.fractionLength(1))), unit: "公里", caption: "累计距离")
                }
                VStack(alignment: .leading, spacing: 16) {
                    MetricLabel(value: "\(workouts.count)", unit: "次", caption: "运动次数")
                    MetricLabel(value: workouts.reduce(0) { $0 + $1.distance }.formatted(.number.precision(.fractionLength(1))), unit: "公里", caption: "累计距离")
                }
            }
        }
        .padding(20).background(MotionStyle.surface, in: RoundedRectangle(cornerRadius: 24))
    }

    private var activityBreakdown: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("运动偏好").font(.title3.weight(.semibold))
            ForEach(WorkoutKind.allCases) { kind in
                let minutes = workouts.filter { $0.kind == kind }.reduce(0) { $0 + $1.durationMinutes }
                VStack(spacing: 10) {
                    HStack {
                        Label(kind.rawValue, systemImage: kind.symbol).font(.body)
                        Spacer()
                        Text("\(minutes) 分钟").font(.subheadline).foregroundStyle(.secondary)
                    }
                    ProgressView(value: Double(minutes), total: Double(max(totalMinutes, 1)))
                        .tint(kind.color)
                        .accessibilityLabel(kind.rawValue)
                        .accessibilityValue("\(minutes) 分钟")
                }
            }
        }
    }

    private var consistency: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("每一步都有回响").font(.title3.weight(.semibold))
            Text("最近 \(period) 天里，你有 \(days.filter { !store.on($0).isEmpty }.count) 天留下了运动记录。")
                .font(.body).foregroundStyle(.secondary)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { date in
                    let minutes = store.on(date).reduce(0) { $0 + $1.durationMinutes }
                    RoundedRectangle(cornerRadius: 6)
                        .fill(minutes > 0 ? Color.accentColor.opacity(max(0.3, min(Double(minutes) / 65, 1))) : Color(uiColor: .quaternarySystemFill))
                        .frame(height: 30)
                        .accessibilityLabel("\(date.formatted(date: .abbreviated, time: .omitted))，运动 \(minutes) 分钟")
                }
            }
        }
    }
}
