//
//  AddPlacePrimaryButton.swift
//  FindMySpot
//

import SwiftUI

struct AddPlacePrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(AppTypography.label)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            AddPlaceStyle.accent.opacity(isDisabled ? 0.45 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .disabled(isDisabled || isLoading)
    }
}
