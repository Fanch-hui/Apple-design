import SwiftUI

struct SessionView: View {
    @Environment(ActivityStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @State private var kind: WorkoutKind = .run
    @State private var firstStart: Date?
    @State private var runningSince: Date?
    @State private var accumulatedSeconds: TimeInterval = 0
    @State private var showDiscardConfirmation = false
    @ScaledMetric(relativeTo: .largeTitle) private var timerSize: CGFloat = 48
    @ScaledMetric(relativeTo: .largeTitle) private var ringSize: CGFloat = 270

    private var hasStarted: Bool { firstStart != nil }
    private var isRunning: Bool { runningSince != nil }

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let elapsed = elapsedSeconds(at: context.date)
                ScrollView {
                    VStack(spacing: 28) {
                        activityPicker
                        timerDisplay(elapsed: elapsed)
                        Text(statusText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("不足 1 分钟按 1 分钟记录")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    actions
                        .frame(maxWidth: 420)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(.bar)
                }
            }
            .background(MotionStyle.background)
            .navigationTitle("运动计时")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭", systemImage: "xmark") {
                        if hasStarted {
                            showDiscardConfirmation = true
                        } else {
                            dismiss()
                        }
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .confirmationDialog("放弃本次运动？", isPresented: $showDiscardConfirmation,
                                titleVisibility: .visible) {
                Button("放弃运动", role: .destructive) { dismiss() }
                Button("继续运动", role: .cancel) { }
            } message: {
                Text("本次计时将不会保存。")
            }
            .interactiveDismissDisabled(hasStarted)
        }
    }

    private var activityPicker: some View {
        VStack(spacing: 10) {
            Text("选择运动")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker("运动类型", selection: $kind) {
                ForEach(WorkoutKind.allCases) { kind in
                    Text(kind.rawValue).tag(kind)
                }
            }
            .pickerStyle(.segmented)
            .disabled(hasStarted)
        }
    }

    private func timerDisplay(elapsed: TimeInterval) -> some View {
        let progress = elapsed / Double(store.dailyGoal * 60)
        return ZStack {
            ActivityRing(progress: progress, lineWidth: 12)
            VStack(spacing: 12) {
                Image(systemName: kind.symbol)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                Text(timerText(elapsed))
                    .font(.system(size: timerSize, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .accessibilityLabel("运动时长")
                    .accessibilityValue(accessibleDuration(elapsed))
                Text("计时体验")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(36)
        }
        .frame(maxWidth: min(ringSize, 360))
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder private var actions: some View {
        if !hasStarted {
            Button(action: startOrResume) {
                Text("开始运动").frame(maxWidth: .infinity).padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } else {
            let layout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(spacing: 12))
                : AnyLayout(HStackLayout(spacing: 12))
            layout {
                Button(isRunning ? "暂停" : "继续") {
                    if isRunning { pause() } else { startOrResume() }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button("结束并保存", action: save)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
    }

    private var statusText: String {
        if !hasStarted { return "准备好了，就出发吧" }
        return isRunning ? "保持自己的节奏" : "已暂停"
    }

    private func elapsedSeconds(at date: Date) -> TimeInterval {
        accumulatedSeconds + (runningSince.map { max(0, date.timeIntervalSince($0)) } ?? 0)
    }

    private func startOrResume() {
        let now = Date.now
        if firstStart == nil { firstStart = now }
        runningSince = now
    }

    private func pause() {
        accumulatedSeconds = elapsedSeconds(at: .now)
        runningSince = nil
    }

    private func save() {
        let minutes = max(1, Int((elapsedSeconds(at: .now) / 60).rounded()))
        store.add(Workout(kind: kind, title: kind.rawValue, date: firstStart ?? .now,
                          durationMinutes: minutes, distance: 0, energy: 0))
        dismiss()
    }

    private func timerText(_ elapsed: TimeInterval) -> String {
        let seconds = max(0, Int(elapsed))
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds / 60) % 60, seconds % 60)
    }

    private func accessibleDuration(_ elapsed: TimeInterval) -> String {
        let seconds = max(0, Int(elapsed))
        return "\(seconds / 3600) 小时，\((seconds / 60) % 60) 分钟，\(seconds % 60) 秒"
    }
}
