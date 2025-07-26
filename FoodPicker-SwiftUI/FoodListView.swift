//
//  FoodListView.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/16.
//

import SwiftUI

private enum Sheet: View, Identifiable {
    case newFood((Food) -> Void)
    case editFood(Binding<Food>)
    case foodDetail(Food)
    
    var id: UUID {
        switch self {
        case .newFood( _):
            return UUID()
        case .editFood(let binding):
            return binding.wrappedValue.id
        case .foodDetail(let food):
            return food.id
        }
    }
    
    var body: some View {
        switch self {
        case .newFood(let onSubmit):
            FoodListView.FoodForm(food: .new, onSubmit: onSubmit)
        case .editFood(let binding):
            FoodListView.FoodForm(food: binding.wrappedValue) { binding.wrappedValue = $0 }
        case .foodDetail(let food):
            FoodListView.FoodDetailSheet(food: food)
        }
    }
}

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @State private var food = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    
    @State private var shouldShowSheet = false
    @State private var sheet: Sheet?
    
    //    @State private var shouldShowFoodForm = false
    //    @State private var selectedFood: Binding<Food>?
    
    var isEditing: Bool {
        editMode?.wrappedValue == .active
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // food sheet
            titleBar
            
            List($food, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRow)
                .listStyle(.plain)
                .padding(.horizontal)
            
        }.background(.groupBG)
            .safeAreaInset(edge: .bottom, content: buildFloatButton)
            .sheet(item: $sheet) { $0 }
    }
}

private extension FoodListView {
    struct FoodDetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct FoodDetailSheet: View {
        
        @State private var foodDetailHeight: CGFloat = FoodDetailSheetHeightKey.defaultValue
        let food: Food
        @Environment(\.dynamicTypeSize) var textSize
        
        var body: some View {
            let shouldVStack = textSize.isAccessibilitySize || food.image.count > 1
            
            AnyLayout.useVStack(if: shouldVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    buildNutritionView(title: "熱量", value: food.$carb)
                    buildNutritionView(title: "蛋白質", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                }
            }
            .padding()
            .padding(.vertical)
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height)
                    
                }
            }
            .onPreferenceChange(FoodDetailSheetHeightKey.self) {
                foodDetailHeight = $0
            }
            .presentationDetents([.height(foodDetailHeight)])
        }
        
        func buildNutritionView(title: String, value: String) -> some View {
            GridRow {
                Text(title).gridCellAnchor(.leading)
                Text(value).gridCellAnchor(.trailing)
            }
        }
    }
}

private extension FoodListView {
    var titleBar: some View {
        HStack {
            Label("食物清單", systemImage: "fork.knife")
                .font(.title.bold())
                .foregroundColor(.cyan)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            EditButton()
                .buttonStyle(.bordered)
                .foregroundColor(.cyan)
                .environment(\.locale, Locale(identifier: "zh_TW"))
        } .padding()
    }
    
    var addButton: some View {
        Button {
            print("addButton Tapped")
            sheet = .newFood { food.append($0) }
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.white, .cyan)
                .padding()
        }
    }
    
    var removeButton: some View {
        Button {
            withAnimation {
                food = food.filter { !selectedFoodID.contains($0.id)}
            }
        } label: {
            Text("刪除已選項目")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .mainButtonStyle(shape: .roundedRectangle(radius: 8))
        .foregroundStyle(.groupBG)
        .padding(.horizontal, 50)
    }
    
    func buildFloatButton() -> some View {
        ZStack {
            removeButton
                .transition(.move(edge:.leading))
                .opacity(isEditing ? 1 : 0)
                .id(isEditing)
            
            HStack {
                Spacer()
                addButton
                    .scaleEffect(isEditing ? 0.0001 : 1)
                    .opacity(isEditing ? 0 : 1)
                    .animation(.easeInOut, value: isEditing)
                    .id(isEditing)
            }
        }
    }
    
    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name).padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing {
                        selectedFoodID.insert(food.id)
                        return
                    }
                    sheet = .foodDetail(food)
                }
            
            if isEditing {
                Image(systemName: "pencil")
                    .font(.title2.bold())
                    .foregroundColor(.cyan)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

#Preview {
    FoodListView()
}

//// 用這段來測試 針對不同狀態 來設計畫面
//struct FoodListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodListView().environment(\.editMode, .constant(.active))
//    }
//}
