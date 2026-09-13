//
//  SignUpView.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var email = StringUtil.EMPTY
    @State private var password = StringUtil.EMPTY
    @State private var passwordConfirmation = StringUtil.EMPTY
    @State private var validationMessage: String?

    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
        case passwordConfirmation
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSubmit: Bool {
        !normalizedEmail.isEmpty
            && password.count >= 8
            && password == passwordConfirmation
            && !auth.isSubmitting
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header

                fields

                if let message = validationMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let errorMessage = auth.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    handleSubmit()
                } label: {
                    HStack {
                        if auth.isSubmitting {
                            ProgressView()
                        }
                    }

                    Text("Create Account")
                }
                .frame(maxWidth: .infinity)

            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
        .onSubmit {
            handleSubmit()
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 42))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("Join FindMySpot")
                .font(.title2.bold())

            Text(
                "Create and account and discover and contribute public places."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }

    private var fields: some View {
        VStack(spacing: 0) {
            TextField("Email address", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .padding()

            Divider()
                .padding(.leading)

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .passwordConfirmation
                }
                .padding()

            Divider()
                .padding(.leading)

            Divider()
                .padding(.leading)

            SecureField("Confirm Password", text: $passwordConfirmation)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirmation)
                .submitLabel(.go)
                .padding()

        }
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.2))
        }
    }

    private func handleSubmit() {
        validationMessage = nil

        guard !normalizedEmail.isEmpty else {
            validationMessage = "Please enter an email address."
            focusedField = .email
            return
        }

        guard password.count >= 8 else {
            validationMessage = "Password must be at least 8 characters."
            focusedField = .password
            return
        }

        guard password == passwordConfirmation else {
            validationMessage = "Passwords do not match."
            focusedField = .passwordConfirmation
            return
        }

        focusedField = nil

        Task {
            await auth.signUp(email: normalizedEmail, password: password)
        }
    }

}
