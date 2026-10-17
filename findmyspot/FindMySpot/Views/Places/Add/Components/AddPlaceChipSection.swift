//
//  AddPlaceChipSection.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceChipSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.titleSmall)

            FlowLayout(spacing: AppSpacing.sm) {
                content
            }
        }
    }
}
