//
//  AuthCard.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: LayoutConstants.horizontalPadding) {
            content()
        }
        .padding(24)
        .background {
            RoundedRectangle(
                cornerRadius: LayoutConstants.cardCornerRadius,
                style: .continuous
            )
            .fill(Color(.systemBackground))
        }
        .shadow(
            color: .black.opacity(0.08),
            radius: 24,
            y: 12
        )
    }
}
