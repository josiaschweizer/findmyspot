//
//  AddPlaceTextField.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(label)
                .font(AppTypography.label)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 54)
                .background(AppColors.elevatedBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(AppColors.borderDefault)
                }
        }
    }
}
