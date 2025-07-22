//
//  Suffix.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/12.
//


@propertyWrapper struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    var projectedValue: String {
        wrappedValue.formatted() + "\(suffix)"
    }
}
