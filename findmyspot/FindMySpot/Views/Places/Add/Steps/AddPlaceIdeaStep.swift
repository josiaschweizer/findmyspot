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
                eyebrow: "01 · THE IDEA",
                title: "Add place",
                subtitle: "Share a publicly accessible spot."
            )

            AddPlaceTextField(
                label: "Place name",
                placeholder: "e.g. My favorite bench",
                text: $viewModel.name
            )

            AddPlaceTextField(
                label: "Address / location description",
                placeholder: "Street or precise directions",
                text: $viewModel.addressDescription
            )

            AppTextArea(
                title: "What makes this place special?",
                placeholder: "Describe yourt spot…",
                text: $viewModel.details
            )
        }
    }
}
