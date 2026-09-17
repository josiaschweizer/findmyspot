//
//  SignUpView.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var auth

    @State private var displayName = StringUtil.EMPTY
    @State private var email = StringUtil.EMPTY
    @State private var password = StringUtil.EMPTY
    @State private var confirmPassword = StringUtil.EMPTY

    @FocusState private var focusedField: Field?

    private enum Field {
        case displayName
        case email
        case password
        case confirmPassword
    }

    private var normalizedDisplayName: String {
        displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var passwordsMatch: Bool {
        password == confirmPassword
    }

    private var canSubmit: Bool {
        !normalizedDisplayName.isEmpty
            && !normalizedEmail.isEmpty
            && !password.isEmpty
            && !confirmPassword.isEmpty
            && !auth.isSubmitting
            && passwordsMatch
    }

    private func handleSubmit() {
        guard canSubmit else {
            return
        }

        focusedField = nil

        Task {
            await auth.signUp(
                displayName: normalizedDisplayName,
                email: normalizedEmail,
                password: password
            )
        }
    }

    var body: some View {
        ZStack {
            AuthBackground()

            ScrollView {
                VStack(spacing: 32) {
                    AuthBrandHeader(
                        title: "Create account",
                        subtitle:
                            "Create your account and start discovering places around you"
                    )

                    AuthCard {
                        AuthTextField(
                            title: "Display name",
                            systemImage: "person",
                            text: $displayName
                        )
                        .textContentType(.name)
                        .focused($focusedField, equals: .displayName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .email
                        }

                        AuthTextField(
                            title: "Email address",
                            systemImage: "envelope",
                            text: $email
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }

                        AuthSecureField(
                            title: "Password",
                            text: $password
                        )
                        .textContentType(.newPassword)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .confirmPassword
                        }

                        AuthSecureField(
                            title: "Confirm password",
                            text: $confirmPassword
                        )
                        .textContentType(.newPassword)
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit {
                            handleSubmit()
                        }

                        if !confirmPassword.isEmpty && !passwordsMatch {
                            AuthErrorMessage(
                                message: "passwords do not match."
                            )
                        }

                        if let errorMessage = auth.errorMessage {
                            AuthErrorMessage(message: errorMessage)
                        }

                        AuthPrimaryButton(
                            title: "Create Account",
                            isLoading: auth.isSubmitting,
                            isEnabled: canSubmit
                        ) {
                            handleSubmit()
                        }

                        AuthFooterLink(
                            text: "Already have an account?",
                            linkText: "Sign In",
                            destination: SignInView()
                        )
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var auth = AuthViewModel()

    NavigationStack {
        SignUpView()
    }
    .environment(auth)
}
