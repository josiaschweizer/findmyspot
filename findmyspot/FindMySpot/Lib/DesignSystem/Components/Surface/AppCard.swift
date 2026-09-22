//
//  AppCard.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppCard<Content: View>: View {
    private let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.lg)
            .background(AppColors.surfaceWhite)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.lg
                )
            )
    }
}
