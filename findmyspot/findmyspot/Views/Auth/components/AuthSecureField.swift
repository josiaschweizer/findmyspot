//
//  AuthSecureField.swift
//  findmyspot
//
//  Created by Josia Schweizer on 17.09.2026.
//

import SwiftUI

struct AuthSecureField: View {
    let title: String

    @Binding var text: String

    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock")
                .frame(width: 22)
                .foregroundStyle(.secondary)

            Group {
                if isVisible {
                    TextField(title, text: $text)
                } else {
                    SecureField(title, text: $text)
                }
            }
            .textContentType(.password)

            Button {
                isVisible.toggle()
            } label: {
                Image(
                    systemName: isVisible ? "eye.slash" : "eye"
                )
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(height: 58)
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
    @Previewable @State var password = "password1234"

    AuthSecureField(
        title: "Password",
        text: $password
    )
    .padding()
}
