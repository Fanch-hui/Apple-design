import SwiftUI
import Charts

struct WorkoutDetailView: View {
    let workout: Workout
    @ScaledMetric(relativeTo: .largeTitle) private var primarySize: CGFloat = 52

    private var isPaceActivity: Bool { workout.kind == .run || workout.kind == .walk }
    private var dateText: String {
        workout.date.formatted(
            .dateTime.year().month().day().weekday(.wide).hour().minute()
                .locale(Locale(identifier: "zh_CN"))
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                heading
                primaryMetric
                summaryMetrics
                Divider()
                HeartRateExampleChart()
                if !workout.note.isEmpty {
                    noteSection
                }
                dateSection
            }
            .frame(maxWidth: 640, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
        }
        .background(MotionStyle.background)
        .navigationTitle("运动详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heading: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(workout.kind.rawValue, systemImage: workout.kind.symbol)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(workout.kind.color)
            Text(workout.title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            Text(dateText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var primaryMetric: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(workout.kind.hasDistance ? "运动距离" : "运动时长")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(workout.kind.hasDistance ? workout.distanceText : "\(workout.durationMinutes)")
                    .font(.system(size: primarySize, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                Text(workout.kind.hasDistance ? "公里" : "分钟")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }

    private var summaryMetrics: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 0) {
                metrics
            }
            VStack(alignment: .leading, spacing: 18) {
                metrics
            }
        }
    }

    @ViewBuilder private var metrics: some View {
        if workout.kind.hasDistance {
            MetricLabel(value: "\(workout.durationMinutes)", unit: "分钟", caption: "运动时长")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        if isPaceActivity {
            MetricLabel(value: workout.paceText, unit: "/公里", caption: "平均配速")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        MetricLabel(value: workout.energyText, unit: "千卡", caption: "活动能量")
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("运动感受").font(.title3.weight(.semibold))
            Text(workout.note)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var dateSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("记录时间").foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(dateText).multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private struct HeartRateExampleChart: View {
    private struct Point: Identifiable {
        let id: Int
        let heartRate: Double
        var progress: Double { Double(id) / 7 }
    }

    private let points: [Point] = [104, 118, 132, 127, 143, 139, 148, 133]
        .enumerated().map { Point(id: $0.offset, heartRate: Double($0.element)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("心率变化").font(.title3.weight(.semibold))
                Spacer()
                Text("示意曲线").font(.footnote).foregroundStyle(.secondary)
            }
            Chart(points) { point in
                AreaMark(
                    x: .value("运动进度", point.progress),
                    yStart: .value("基线", 90.0),
                    yEnd: .value("心率", point.heartRate)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(colors: [.accentColor.opacity(0.2), .accentColor.opacity(0.02)],
                                   startPoint: .top, endPoint: .bottom)
                )
                LineMark(x: .value("运动进度", point.progress), y: .value("心率", point.heartRate))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(Color.accentColor)
            }
            .chartYScale(domain: 90.0...170.0)
            .chartYAxis {
                AxisMarks(position: .leading, values: [100.0, 130.0, 160.0])
            }
            .chartXAxis {
                AxisMarks(values: [0.0, 0.5, 1.0]) { value in
                    AxisValueLabel {
                        if let progress = value.as(Double.self) {
                            Text(progressLabel(progress))
                        }
                    }
                }
            }
            .frame(height: 155)
            .accessibilityLabel("心率变化示意曲线")
            .accessibilityValue("示例数据")
            Text("心率 · 次/分钟")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(MotionStyle.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private func progressLabel(_ progress: Double) -> String {
        if progress == 0 { return "开始" }
        if progress == 1 { return "结束" }
        return "中段"
    }
}
