import SwiftUI
import Charts

struct TodayView: View {
    @Environment(ActivityStore.self) private var store
    @ScaledMetric(relativeTo: .largeTitle) private var distanceSize: CGFloat = 52
    let onStart: () -> Void
    let onHistory: () -> Void
    let onSettings: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text(Date.now, format: .dateTime.month(.wide).day().weekday(.wide))
                        .font(.subheadline).foregroundStyle(.secondary)
                        .padding(.top, 4)
                    activitySummary
                    Button(action: onStart) {
                        Label("开始运动", systemImage: "play.fill")
                            .font(.headline).frame(maxWidth: .infinity, minHeight: 40)
                    }
                    .buttonStyle(.borderedProminent).buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .padding(.top, -12)
                    weekSection
                    recentSection
                    Text("每一次出发，都算数。")
                        .font(.footnote).foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                .padding(.horizontal, 20).padding(.bottom, 24)
                .frame(maxWidth: 650)
                .frame(maxWidth: .infinity)
            }
            .background(MotionStyle.background)
            .navigationTitle("今日")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onSettings) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2).frame(minWidth: 44, minHeight: 44)
                    }
                    .accessibilityLabel("个人与设置")
                }
            }
        }
    }

    private var activitySummary: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("今日活动").font(.headline)
                Spacer()
                Text(store.todayMinutes >= store.dailyGoal ? "目标达成" : "保持节奏")
                    .font(.subheadline).foregroundStyle(Color.accentColor)
            }
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 20) {
                    distanceMetric
                    Spacer(minLength: 0)
                    goalRing
                }
                VStack(alignment: .leading, spacing: 20) {
                    distanceMetric
                    goalRing
                }
            }
            Divider()
            ViewThatFits(in: .horizontal) {
                HStack {
                    MetricLabel(value: "\(store.todayMinutes)", unit: "分钟", caption: "运动时长")
                    Spacer(minLength: 12)
                    MetricLabel(value: "\(store.todayEnergy)", unit: "千卡", caption: "活动消耗")
                    Spacer(minLength: 12)
                    MetricLabel(value: "\(store.todayWorkouts.count)", unit: "次", caption: "完成运动")
                }
                VStack(alignment: .leading, spacing: 16) {
                    MetricLabel(value: "\(store.todayMinutes)", unit: "分钟", caption: "运动时长")
                    MetricLabel(value: "\(store.todayEnergy)", unit: "千卡", caption: "活动消耗")
                    MetricLabel(value: "\(store.todayWorkouts.count)", unit: "次", caption: "完成运动")
                }
            }
        }
        .padding(20)
        .background(MotionStyle.surface, in: RoundedRectangle(cornerRadius: 24))
    }

    private var distanceMetric: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("累计距离").font(.subheadline).foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(store.todayDistance, format: .number.precision(.fractionLength(2)))
                    .font(.system(size: distanceSize, weight: .semibold, design: .rounded))
                    .tracking(-2).monospacedDigit()
                Text("公里").font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var goalRing: some View {
        ZStack {
            ActivityRing(progress: store.goalProgress, lineWidth: 9)
            VStack(spacing: 2) {
                Text("\(Int(store.goalProgress * 100))%")
                    .font(.title2.weight(.semibold)).fontDesign(.rounded).monospacedDigit()
                Text("每日目标").font(.caption2).foregroundStyle(.secondary)
            }
        }
        .frame(width: 108, height: 108)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("每日运动目标")
        .accessibilityValue("已完成 \(store.todayMinutes) 分钟，目标 \(store.dailyGoal) 分钟")
    }

    private var weekSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeading(title: "最近 7 天") {
                Text("\(store.weekWorkouts.count) 次运动").font(.subheadline).foregroundStyle(.secondary)
            }
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(store.weekWorkouts.reduce(0) { $0 + $1.durationMinutes }, format: .number)
                    .font(.title.weight(.semibold)).fontDesign(.rounded).monospacedDigit()
                Text("分钟").font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                Text(remainingMessage).font(.footnote).foregroundStyle(.secondary)
            }
            Chart(store.recentDays, id: \.self) { date in
                BarMark(x: .value("日期", date, unit: .day),
                        y: .value("分钟", store.on(date).reduce(0) { $0 + $1.durationMinutes }), width: .ratio(0.45))
                    .foregroundStyle(Calendar.current.isDateInToday(date) ? Color.accentColor : Color.accentColor.opacity(0.22))
                    .cornerRadius(5)
            }
            .chartXAxis {
                AxisMarks(values: store.recentDays) { value in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                }
            }
            .chartYAxis(.hidden)
            .chartYScale(domain: 0...max(75, store.recentDays.map { date in
                store.on(date).reduce(0) { $0 + $1.durationMinutes }
            }.max() ?? 75))
            .frame(height: 104)
            .accessibilityLabel("最近七天运动时长")
        }
    }

    private var remainingMessage: String {
        let remaining = store.dailyGoal - store.todayMinutes
        return remaining > 0 ? "今天再动 \(remaining) 分钟" : "今天的目标已完成"
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "最近运动") {
                Button("全部", action: onHistory).font(.subheadline)
                    .frame(minHeight: 44)
            }
            ForEach(Array(store.sortedWorkouts.prefix(3))) { workout in
                NavigationLink {
                    WorkoutDetailView(workout: workout)
                } label: {
                    HStack(spacing: 10) {
                        WorkoutRow(workout: workout)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold)).foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if workout.id != store.sortedWorkouts.prefix(3).last?.id {
                    Divider().padding(.leading, 56)
                }
            }
        }
    }
}
