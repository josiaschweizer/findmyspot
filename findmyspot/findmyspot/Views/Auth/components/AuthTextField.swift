//
//  AuthTextField.swift
//  findmyspot
//
//  Created by Josia Schweizer on 17.09.2026.
//

import SwiftUI

struct AuthTextField: View {
    let title: String
    let systemImage: String

    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 22)
                .foregroundStyle(.secondary)

            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .frame(height: 58)
        .background {
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(Color(.secondarySystemBackground))
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .stroke(
                Color.primary.opacity(0.08),
                lineWidth: 1
            )
        }
    }
}

#Preview {
    @Previewable @State var text = "Was für einen Text?"

    AuthTextField(
        title: "Test Title",
        systemImage: "tree",
        text: $text
    )
    .padding()
}
