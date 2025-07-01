//
//  FoodPicker_SwiftUIApp.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/2.
//

import SwiftUI

@main
struct FoodPicker_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
