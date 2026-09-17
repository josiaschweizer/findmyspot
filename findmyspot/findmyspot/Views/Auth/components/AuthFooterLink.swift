//
//  AuthFooterLink.swift
//  findmyspot
//
//  Created by Josia Schweizer on 17.09.2026.
//

import SwiftUI

struct AuthFooterLink<Destination: View>: View {
    let text: String
    let linkText: String
    let destination: Destination

    var body: some View {
        HStack(spacing: 4) {
            Text(text).foregroundStyle(.secondary)

            NavigationLink {
                destination
            } label: {
                Text(linkText)
                    .foregroundStyle(AppColors.primary)
                    .fontWeight(.semibold)
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        AuthFooterLink(
            text: "Already have an account?",
            linkText: "Sign In",
            destination: Text("Sign In")
        )
        .padding()
    }
}
