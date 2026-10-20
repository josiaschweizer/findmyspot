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
        AppTextField(
            title: label,
            placeholder: placeholder,
            text: $text
        )
        .textInputAutocapitalization(.sentences)
    }
}
