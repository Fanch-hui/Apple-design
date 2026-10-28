import SwiftUI

struct AddWorkoutView: View {
    @Environment(ActivityStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var kind: WorkoutKind = .run
    @State private var title = ""
    @State private var date = Date.now
    @State private var durationText = ""
    @State private var distanceText = ""
    @State private var energyText = ""
    @State private var attemptedSave = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case title, duration, distance, energy
    }

    private var trimmedTitle: String { title.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var duration: Int? { Int(durationText.trimmingCharacters(in: .whitespaces)) }
    private var distance: Double? { decimalValue(distanceText) }
    private var energy: Int? { Int(energyText.trimmingCharacters(in: .whitespaces)) }

    var body: some View {
        NavigationStack {
            Form {
                Section("运动信息") {
                    Picker("运动类型", selection: $kind) {
                        ForEach(WorkoutKind.allCases) { kind in
                            Label(kind.rawValue, systemImage: kind.symbol).tag(kind)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("名称").font(.subheadline).foregroundStyle(.secondary)
                        TextField("例如：江边晨跑", text: $title)
                            .accessibilityLabel("名称")
                            .focused($focusedField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .duration }
                        if attemptedSave && trimmedTitle.isEmpty {
                            fieldError("请输入运动名称。")
                        }
                    }
                    .padding(.vertical, 4)
                    DatePicker("日期", selection: $date, in: ...Date.now,
                               displayedComponents: [.date, .hourAndMinute])
                }

                Section("运动数据") {
                    numberField("时长", placeholder: "例如：30", unit: "分钟",
                                text: $durationText, field: .duration, keyboard: .numberPad)
                    if attemptedSave && (duration == nil || !(1...1440).contains(duration ?? 0)) {
                        fieldError("请输入 1 到 1440 分钟的时长。")
                    }
                    if kind.hasDistance {
                        numberField("距离（选填）", placeholder: "例如：5.2", unit: "公里",
                                    text: $distanceText, field: .distance, keyboard: .decimalPad)
                        if attemptedSave && !distanceText.isEmpty && (distance == nil || !(distance ?? 0).isFinite || (distance ?? 0) <= 0) {
                            fieldError("请输入大于 0 的距离。")
                        }
                    }
                    numberField("消耗（选填）", placeholder: "例如：280", unit: "千卡",
                                text: $energyText, field: .energy, keyboard: .numberPad)
                    if attemptedSave && !energyText.isEmpty && (energy == nil || (energy ?? -1) < 0) {
                        fieldError("请输入不小于 0 的热量。")
                    }
                }
            }
            .navigationTitle("添加记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存", action: save)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完成") { focusedField = nil }
                }
            }
        }
    }

    private func numberField(_ label: String, placeholder: String, unit: String,
                             text: Binding<String>, field: Field, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            HStack {
                TextField(placeholder, text: text)
                    .accessibilityLabel(label)
                    .accessibilityHint("单位：\(unit)")
                    .keyboardType(keyboard)
                    .focused($focusedField, equals: field)
                Text(unit).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func fieldError(_ message: String) -> some View {
        Text(message).font(.footnote).foregroundStyle(.red)
    }

    private func decimalValue(_ text: String) -> Double? {
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(value.replacingOccurrences(of: ",", with: "."))
    }

    private func save() {
        attemptedSave = true
        guard !trimmedTitle.isEmpty else { focusedField = .title; return }
        guard let duration, (1...1440).contains(duration) else { focusedField = .duration; return }
        if kind.hasDistance, !distanceText.isEmpty {
            guard let distance, distance.isFinite, distance > 0 else { focusedField = .distance; return }
        }
        if !energyText.isEmpty {
            guard let energy, energy >= 0 else { focusedField = .energy; return }
        }

        store.add(Workout(kind: kind, title: trimmedTitle, date: date, durationMinutes: duration,
                          distance: kind.hasDistance ? (distance ?? 0) : 0, energy: energy ?? 0))
        dismiss()
    }
}
