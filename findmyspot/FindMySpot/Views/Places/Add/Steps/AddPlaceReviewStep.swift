//
//  AddPlaceReviewStep.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceReviewStep: View {
    let viewModel: AddPlaceViewModel

    private var tags: [String] {
        viewModel.selectedActivities.map(\.title).sorted()
            + viewModel.selectedFeatures.map(\.title).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            AddPlaceSectionTitle(
                eyebrow: "03 · FAST GESCHAFFT",
                title: "Angaben prüfen"
            )

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text(viewModel.name)
                    .font(AppTypography.titleSmall)

                Text(viewModel.addressDescription)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)

                Text(viewModel.details)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !tags.isEmpty {
                    FlowLayout(spacing: AppSpacing.sm) {
                        ForEach(tags, id: \.self) { tag in
                            AppTag(tag)
                        }
                    }
                }

                Text(positionText)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.top, AppSpacing.xs)
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.elevatedBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.borderDefault)
            }
        }
    }

    private var positionText: String {
        let latitude = viewModel.latitude.formatted(
            .number.precision(.fractionLength(4))
        )
        let longitude = viewModel.longitude.formatted(
            .number.precision(.fractionLength(4))
        )
        return "Position: \(latitude), \(longitude)"
    }
}
