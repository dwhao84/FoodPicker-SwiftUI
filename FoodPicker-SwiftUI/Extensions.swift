//
//  Extensions.swift
//  FoodPicker-SwiftUI
//
//  Created by Dawei Hao on 2025/7/12.
//

import SwiftUI

extension AnyTransition {
    static let delayInsertionOpacity = Self.asymmetric(
        insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)),
        removal: .opacity.animation(.easeInOut(duration: 0.4))
    )
    
    static let moveEdgeToTop = Self.move(edge: .top)
}

extension Color {
    static let secondarySystemBackground: Color = Color(.secondarySystemBackground)
}

extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.5)
    static let myEaseInOutFast = Animation.easeInOut(duration: 0.6)
}

extension View {
    func mainButtonStyle() -> some View {
            buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
    }
    
    func roundedRectBackground (radius: CGFloat = 8,
                                fill: some ShapeStyle = Color(.systemBackground))
    -> some View {
        background(RoundedRectangle(cornerRadius: radius).foregroundStyle(fill))
    }
}
