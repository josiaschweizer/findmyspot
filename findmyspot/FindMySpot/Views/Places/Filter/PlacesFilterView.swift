//
//  PlacesFilterView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 29.09.2026.
//

import SwiftUI

struct PlacesFilterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: PlaceFilter

    private let purposes: [Purpose]
    private let features: [Feature]
    private let onApply: (PlaceFilter) -> Void

    init(
        purposes: [Purpose],
        features: [Feature],
        selection: PlaceFilter,
        onApply: @escaping (PlaceFilter) -> Void
    ) {
        self.purposes = purposes.sorted {
            $0.sortOrder < $1.sortOrder
        }

        self.features =
            features
            .filter { $0.type == .boolean }
            .sorted { $0.sortOrder < $1.sortOrder }

        self.onApply = onApply
        _draft = State(initialValue: selection)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    purposesSection
                    featureSection
                }
                .padding(AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    AppIconButton(
                        icon: AppIcons.close,
                        isEnabled: true
                    ) {
                        dismiss()
                    }
                    .accessibilityLabel("Close Filter")
                }
            }
            .safeAreaInset(edge: .bottom) {
                footer
            }
        }
    }

    private var purposesSection: some View {
        AppCard {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.md
            ) {
                Text("What are your plans?")
                    .font(AppTypography.titleSmall)
                    .foregroundStyle(AppColors.textPrimary)

                Text("At least one selected Activity must match.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)

                FlowLayout(spacing: AppSpacing.sm) {
                    ForEach(purposes) { purpose in
                        AppChoice(
                            title: purpose.name ?? purpose.slug,
                            isSelected: draft.isSelected(purpose: purpose)
                        ) {
                            draft.toggle(purpose: purpose)
                        }
                        .accessibilityAddTraits(
                            draft.purposeIDs.contains(purpose.id)
                                ? .isSelected : []
                        )
                    }
                }

                if purposes.isEmpty {
                    Text("No activity available.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var featureSection: some View {
        AppCard {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.md
            ) {
                Text("What do you need for your activity?")
                    .font(AppTypography.titleSmall)
                    .foregroundStyle(AppColors.textPrimary)

                Text("All selected features must be available.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)

                FlowLayout(spacing: AppSpacing.sm) {
                    ForEach(features) { feature in
                        AppChoice(
                            title: feature.name ?? feature.slug,
                            isSelected: draft.isSelected(feature: feature)
                        ) {
                            draft.toggle(feature: feature)
                        }
                        .accessibilityAddTraits(
                            draft.isSelected(feature: feature)
                                ? .isSelected : []
                        )
                    }
                }

                if features.isEmpty {
                    Text("No features available.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var footer: some View {
        VStack(spacing: AppSpacing.sm) {
            AppButton("Apply Filters") {
                onApply(draft)
                dismiss()
            }

            AppButton(
                "Reset",
                variant: .secondary,
                isEnabled: !draft.isEmpty
            ) {
                draft = PlaceFilter()
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.background)
    }
}

#Preview {
    PlacesFilterView(
        purposes: [],
        features: [],
        selection: PlaceFilter(),
        onApply: { _ in }
    )
}
