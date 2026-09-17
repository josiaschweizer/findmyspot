//
//  SignInView.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

import SwiftUI

struct SignInView: View {
    @Environment(AuthViewModel.self) private var auth

    @State private var email = StringUtil.EMPTY
    @State private var password = StringUtil.EMPTY

    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSubmit: Bool {
        !normalizedEmail.isEmpty && !password.isEmpty && !auth.isSubmitting
    }

    private func handleSubmit() {
        guard canSubmit else {
            return
        }

        focusedField = nil

        Task {
            await auth.signIn(
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
                        title: "Welcome back",
                        subtitle:
                            "Sign in to continue disovering places around you"
                    )

                    AuthCard {
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
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            handleSubmit()
                        }

                        if let errorMessage = auth.errorMessage {
                            AuthErrorMessage(
                                message: errorMessage
                            )
                        }

                        HStack {
                            Spacer()

                            Button("Forgot password?") {
                                // TODO redirect onto password forgot view
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .disabled(true)
                        }

                        AuthPrimaryButton(
                            title: "Sign In",
                            isLoading: auth.isSubmitting,
                            isEnabled: canSubmit
                        ) {
                            handleSubmit()
                        }

                        AuthFooterLink(
                            text: "Don't have an account?",
                            linkText: "Create account",
                            destination: SignUpView()
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
        SignInView()
    }
    .environment(auth)
}
