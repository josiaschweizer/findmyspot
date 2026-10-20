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

            AppTextArea(
                title: "Was macht den Ort besonders?",
                placeholder: "Beschreibe deinen Spot …",
                text: $viewModel.details
            )
        }
    }
}
