//
//  AddPlaceIdeaStep.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceIdeaStep: View {
    @Bindable var viewModel: AddPlaceViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            AddPlaceSectionTitle(
                eyebrow: "01 · DIE IDEE",
                title: "Ort hinzufügen",
                subtitle: "Teile einen öffentlich zugänglichen Spot."
            )

            AddPlaceTextField(
                label: "Name des Ortes",
                placeholder: "z. B. Meine Lieblingsbank",
                text: $viewModel.name
            )

            AddPlaceTextField(
                label: "Adresse / Lagebeschreibung",
                placeholder: "Strasse oder genauer Hinweis",
                text: $viewModel.addressDescription
            )

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Was macht den Ort besonders?")
                    .font(AppTypography.label)

                ZStack(alignment: .topLeading) {
                    if viewModel.details.isEmpty {
                        Text("Beschreibe deinen Spot …")
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 15)
                    }

                    TextEditor(text: $viewModel.details)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.sm)
                        .frame(minHeight: 112)
                        .foregroundStyle(AppColors.textPrimary)
                }
                .background(AppColors.elevatedBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(AppColors.borderDefault)
                }
            }
        }
    }
}
