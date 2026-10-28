import SwiftUI

struct SettingsView: View {
    @Environment(ActivityStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appearance") private var appearance = "system"

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "figure.run.circle.fill")
                            .font(.system(size: 48)).foregroundStyle(Color.accentColor)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("动迹").font(.title2.weight(.semibold))
                            Text("动起来，找到自己的节奏。")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                Section("每日目标") {
                    Stepper(value: $store.dailyGoal, in: 15...120, step: 5) {
                        LabeledContent("运动时长", value: "\(store.dailyGoal) 分钟")
                    }
                }
                Section("外观") {
                    Picker("显示模式", selection: $appearance) {
                        Text("跟随系统").tag("system")
                        Text("浅色").tag("light")
                        Text("深色").tag("dark")
                    }
                }
                Section {
                    LabeledContent("版本", value: "1.0")
                    Text("运动记录为本地示例数据。你可以添加记录、体验计时，并切换外观。新增运动记录在本次运行中保留。")
                        .font(.footnote).foregroundStyle(.secondary)
                } header: {
                    Text("关于动迹")
                }
            }
            .navigationTitle("个人与设置").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
