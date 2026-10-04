//
//  AppToggleIconButton.swift
//  FindMySpot
//
//  Created by josiaschweizer on 03.10.2026.
//

import SwiftUI

struct AppToggleIconButton: View {
    let icon: String
    let selectedIcon: String
    let isSelected: Bool
    var isEnabled: Bool = true
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? selectedIcon : icon)
                .font(AppTypography.titleMedium)
                .foregroundStyle(
                    isSelected ? AppColors.primary : AppColors.textPrimary
                )
                .keyframeAnimator(
                    initialValue: CGFloat(1),
                    trigger: isSelected
                ) { [reduceMotion] content, scale in
                    content.scaleEffect(reduceMotion ? 1 : scale)
                } keyframes: { _ in
                    LinearKeyframe(CGFloat(1.15), duration: 1)
                    LinearKeyframe(CGFloat(1), duration: 0.15)
                }
                .contentShape(Rectangle())
                .frame(
                    minWidth: AppLayout.minimumControlHeight,
                    minHeight: AppLayout.minimumControlHeight
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleButtonStyle(reduceMotion: reduceMotion))
        .disabled(!isEnabled)
        .sensoryFeedback(trigger: isSelected) { _, newValue in
            newValue ? .success : .impact(weight: .light)
        }
    }

    private struct PressScaleButtonStyle: ButtonStyle {
        let reduceMotion: Bool

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(
                    configuration.isPressed && !reduceMotion ? 0.85 : 1
                )
                .animation(
                    .spring(response: 0.25, dampingFraction: 0.55),
                    value: configuration.isPressed
                )
        }
    }
}
