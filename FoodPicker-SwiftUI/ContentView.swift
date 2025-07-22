//
//  ContentView.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/2.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Property Wrapper
    @State private var selectedFood: Food?
    @State private var shouldShowInfo: Bool = false

    // Call Food裡面的examples
    let food = Food.examples
    
    // MARK: - body
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Food Image
                foodImage
                
                Text("今天吃什麼？").font(.title).bold()
                
                // selected Food Info View
                selectedFoodInfoView
                
                Spacer().layoutPriority(1)
                
                // selected Food Button
                selectedFoodButton
                
                resetButton
            }
            .padding()
            .frame(maxWidth: .infinity)
            .font(.title)
            .mainButtonStyle()
            .tint(.cyan)
            .animation(.mySpring, value: shouldShowInfo) // 彈力效果
            .animation(.myEaseInOutFast, value: selectedFood)
        }.background(.secondarySystemBackground)
    }
}



// MARK: - Subviews
private extension ContentView {
    
    // MARK: - Food Image
    var foodImage: some View {
        Group {
            if let selectedFood {
                Text(selectedFood.image)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
            } else {
                Image("dinner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }.frame(height:250)
    }
    
    // MARK: - foodNameView
    var foodNameView: some View {
        HStack {
            Text(selectedFood!.name)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.green)
                .id(selectedFood!.name)
                .transition(AnyTransition.delayInsertionOpacity)
            
            Button {
                print("點擊 Info Button")
                shouldShowInfo.toggle()
                
            } label: {
                Image(systemName: "info.circle.fill").foregroundStyle(.secondary)
                
            }.buttonStyle(.plain)
        }
    }
    
    // MARK: - foodDetailView
    var foodDetailView: some View {
        VStack {
            if shouldShowInfo {
                Grid() {
                    GridRow {
                        Text("蛋白質")
                        Text("脂肪")
                        Text("碳水")
                    }
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    
                    GridRow {
                        Text(selectedFood!.$protein)
                        Text(selectedFood!.$fat)
                        Text(selectedFood!.$carb)
                    }
                }
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .roundedRectBackground()
                .transition(AnyTransition.move(edge: .top)) // 由上至下的顯示
                .frame(maxWidth: .infinity)
                .clipped()
            }
        }
    }
    
    // MARK: - selectedFoodInfoView
    @ViewBuilder var selectedFoodInfoView: some View {
        if let selectedFood {
            
            // foodNameView
            foodNameView
            
            // text
            Text("熱量 \(Int(selectedFood.calorie))大卡").font(.title2)
            
            // foodDetailView
            foodDetailView
        }
    }
    
    // MARK: - selectedFoodButton
    
    var selectedFoodButton: some View {
        Button {
            // 選出與目前不同的食物
            let availableFoods = food.filter { $0 != selectedFood }
            if let newFood = availableFoods.randomElement() {
                selectedFood = newFood
            }
        } label: {
            Text(selectedFood == .none ? "告訴我!" : "換一個")
                .frame(width: 200)
                .animation(.none, value: selectedFood) // 意思就是不要有動畫，並且是針對 selectedFood的內容。
                .transformEffect(.identity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, -15)
    }
    
    // MARK: - resetButton
    var resetButton: some View {
        Button(role: .none) {
            print("點擊重置")
            selectedFood = .none
            shouldShowInfo = false
        } label: {
            Text("重置")
                .frame(width: 200)
        }
    }
}

#Preview {
    ContentView()
}
