//
//  AuthErrorMessage.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthErrorMessage: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")

            Text(message).font(.subheadline)

            Spacer()
        }
        .foregroundStyle(.red)
        .padding(14)
        .background {
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
            .fill(.red.opacity(0.08))
        }
    }
}
