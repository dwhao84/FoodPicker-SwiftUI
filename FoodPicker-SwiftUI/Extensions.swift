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

extension ShapeStyle where Self == Color {
    static var secondarySystemBackground: Color { Color(.secondarySystemBackground) }
    static var groupBG: Color { Color(.systemGroupedBackground) }
}

extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.5)
    static let myEaseInOutFast = Animation.easeInOut(duration: 0.6)
}

extension View {
    func mainButtonStyle(shape: ButtonBorderShape = .capsule) -> some View {
        buttonStyle(.bordered)
            .buttonBorderShape(shape)
            .controlSize(.large)
    }
    
    func roundedRectBackground (radius: CGFloat = 8, fill: some ShapeStyle = Color(.systemBackground)) -> some View {
        background(RoundedRectangle(cornerRadius: radius).fill(fill))
    }
}

extension AnyLayout {
    static func useVStack(
        if condition: Bool,
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View { // 👈這裡補上回傳型別
        let layout = condition
            ? AnyLayout(VStackLayout(spacing: spacing))
            : AnyLayout(HStackLayout(spacing: spacing))
        
        return layout {
            content()
        }
    }
}
