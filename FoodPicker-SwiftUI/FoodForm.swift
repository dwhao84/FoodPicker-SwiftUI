//
//  FoodForm.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/25.
//

import SwiftUI

private enum MyField: Int {
    case title, image, calories, protein, fat, carb
}

private extension TextField where Label == Text {
    func focused(_ field: FocusState<MyField?>.Binding, equals this: MyField) -> some View {
        submitLabel(this == .carb ? .done : .next)
        .focused(field, equals: this)
        .onSubmit {
            field.wrappedValue = .init(rawValue: this.rawValue + 1)
        }
    }
}

extension FoodListView {
    struct FoodForm: View {
        @Environment(\.dismiss) var dismiss
        @FocusState private var field: MyField?
        @State var food: Food
        var onSubmit: (Food) -> Void
        
        private var isNotValid: Bool {
            food.name.isEmpty || food.image.count > 2
        }
        
        private var invalidMessage: String? {
            if food.name.isEmpty { return "請輸入名稱" }
            if food.image.count > 2 { return "圖示最多輸入2個字元" }
            
            return .none
        }
        
        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        Label("編輯食物資訊", systemImage: "pencil")
                            .font(.title.bold())
                            .foregroundStyle(.cyan)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.secondary)
                            .onTapGesture {
                                dismiss()
                            }
                    }.padding([.horizontal, .top])
                    
                    Form {
                        LabeledContent("名稱") {
                            TextField("必填", text: $food.name)
                                .focused($field, equals: .title)
                        }
                        LabeledContent("圖示") {
                            TextField("最多輸入2個字元", text: $food.image)
                                .focused($field, equals: .image)
                        }
                        
                        buildNumberField(title: "熱量", value: $food.calorie, field: .calories, suffix: "大卡")
                        
                        buildNumberField(title: "蛋白質", value: $food.protein, field: .protein)
                        buildNumberField(title: "脂肪", value: $food.fat, field: .fat)
                    }.padding(.top, -16)
                    
                    Button {
                        dismiss()
                        onSubmit(food)
                        
                    } label: {
                        Text(invalidMessage ?? "儲存")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .mainButtonStyle()
                    .padding()
                    .disabled(isNotValid)
                }
                .background(.groupBG)
                .multilineTextAlignment(.trailing)
                .font(.title3)
                .scrollDismissesKeyboard(.interactively)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: goPreviousField) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Button(action: goNextField) {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
        
        func goPreviousField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue - 1)
        }
        
        func goNextField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue + 1)
        }
        
        // number TextField
        private func buildNumberField(title: String, value: Binding<Double>, field: MyField, suffix: String = "g") -> some View {
            LabeledContent(title) {
                HStack {
                    TextField("", value: value , format:.number.precision(.fractionLength(1)))
                        .focused($field, equals: .title)
                        .keyboardType(.numbersAndPunctuation)
                    Text(suffix)
                }
            }
        }
    }
}

#Preview {
    FoodListView.FoodForm(food: Food.examples.first!) { _ in }
}
