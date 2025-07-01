//
//  ContentView.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/2.
//

import SwiftUI

struct ContentView: View {
    
    let food = ["漢堡", "披薩", "壽司", "炸雞", "薯條", "關東煮"]
    
    // Property Wrapper
    @State private var selectedFood: String?
    
    var body: some View {
        VStack(spacing: 30) {
            Image("dinner")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("今天吃什麼？")
                .font(.title)
                .bold()
            
            if selectedFood != .none {
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.green)
            }
            
            Button {
                // 選出與目前不同的食物
                let availableFoods = food.filter { $0 != selectedFood }
                if let newFood = availableFoods.randomElement() {
                    selectedFood = newFood
                }
            } label: {
                Text(selectedFood == .none ? "告訴我!" : "再點我")
                    .frame(width: 200)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, -15)
            
            Button(role: .none) {
                selectedFood = .none
            } label: {
                Text("重置")
                    .frame(width: 200)
            }
        }
        .padding()
        .font(.title)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .tint(.cyan)
        .animation(.easeInOut, value: selectedFood)
    }
}

#Preview {
    ContentView()
}
