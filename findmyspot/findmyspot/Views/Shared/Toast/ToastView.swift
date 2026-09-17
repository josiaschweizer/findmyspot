//
//  ToastView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.09.2026.
//

import SwiftUI

struct ToastView: View {
    let toast: Toast

    private var icon: String {
        switch toast.type {
        case .success:
            "checkmark.circle.fill"

        case .error:
            "exclamationmark.circle.fill"

        case .info:
            "info.circle.fill"

        }
    }

    private var backgroundColor: Color {
        switch toast.type {
        case .success:
            .green
        case .error:
            .red
        case .info:
            .blue
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.headline)

            Text(toast.message)
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(backgroundColor)
        }
        .shadow(
            color: .black.opacity(0.15),
            radius: 12,
            y: 6
        )
    }
}

#Preview {
    ToastView(
        toast: Toast(
            message: "Account created successfully",
            type: .success
        )
    )
    .padding()
}
