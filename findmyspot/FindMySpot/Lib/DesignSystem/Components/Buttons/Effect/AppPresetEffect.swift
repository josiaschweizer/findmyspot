//
//  AppPresetEffect.swift
//  FindMySpot
//
//  Created by josiaschweizer on 10.10.2026.
//

import SwiftUI

struct AppPresetEffect: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isPressed ? 0.8 : 1)
            .scaleEffect(isPressed ? 0.92 : 1)
            .animation(
                .spring(response: 0.25, dampingFraction: 0.65),
                value: isPressed
            )
    }
}

struct AppPressGesture: ViewModifier {
    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .modifier(AppPresetEffect(isPressed: isPressed))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
            )
    }
}

extension View {
    func appPressedEffect(_ isPressed: Bool) -> some View {
        modifier(AppPresetEffect(isPressed: isPressed))
    }

    func appPressEffect() -> some View {
        modifier(AppPressGesture())
    }
}
