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
        AppButton(
            title,
            isEnabled: !isDisabled,
            isLoading: isLoading,
            action: action
        )
    }
}
