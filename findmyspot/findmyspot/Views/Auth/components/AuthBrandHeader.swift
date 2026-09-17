//
//  AuthBrandHeader.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthBrandHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "mapping")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background {
                    RoundedRectangle(
                        cornerRadius: 72,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
                .shadow(
                    color: Color.accentColor.opacity(0.25),
                    radius: 16,
                    y: 8
                )

            Text("FindMySpot")
                .font(.system(size: 34, weight: .bold))

            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }
}

#Preview {
    AuthBrandHeader(title: "Title", subtitle: "Subtitle")
}
