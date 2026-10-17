//
//  AddPlaceHeader.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceHeader: View {
    let step: Int
    let onBack: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack(spacing: AppSpacing.md) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 42, height: 42)
                        .background(AppColors.elevatedBackground)
                        .clipShape(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(AppColors.borderDefault)
                        }
                }
                .buttonStyle(.plain)

                Text("Ort hinzufügen · \(step + 1) von 3")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()

                Button("Abbrechen", action: onCancel)
                    .font(AppTypography.label)
                    .buttonStyle(.plain)
            }

            HStack(spacing: AppSpacing.xs) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(
                            index <= step
                                ? AddPlaceStyle.accent
                                : AppColors.surfaceSecondary
                        )
                        .frame(height: 4)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.md)
        .background(AppColors.background)
    }
}
