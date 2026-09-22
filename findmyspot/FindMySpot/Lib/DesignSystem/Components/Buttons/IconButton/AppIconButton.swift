//
//  AppIconButton.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppIconButton: View {
    let icon: String
    let variant: AppIconButtonVariant
    let isEnabled: Bool
    let action: () -> Void

    init(
        icon: String,
        variant: AppIconButtonVariant = .plain,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .frame(
                    width: AppLayout.minimumControlHeight,
                    height: AppLayout.minimumControlHeight
                )
        }
        .buttonStyle(
            AppIconButtonStyle(
                variant: variant,
                isEnabled: isEnabled
            )
        )
        .disabled(!isEnabled)
    }
}
