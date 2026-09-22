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
        !normalizedEmail.isEmpty
            && !password.isEmpty
            && !auth.isSubmitting
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
                VStack(spacing: AppSpacing.xxl) {
                    AuthBrandHeader(
                        title: "Welcome back",
                        subtitle: "Sign in to discover places around you."
                    )

                    AppCard {
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.lg
                        ) {
                            emailField
                            passwordField

                            if let errorMessage = auth.errorMessage {
                                AppErrorMessage(message: errorMessage)
                            }

                            AppButton(
                                "Sign In",
                                isEnabled: canSubmit,
                                isLoading: auth.isSubmitting,
                                action: handleSubmit
                            )

                            footer
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.xxl)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emailField: some View {
        AppTextField(
            title: "Email address",
            placeholder: "name@example.com",
            text: $email
        )
        .focused($focusedField, equals: .email)
        .textContentType(.username)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .submitLabel(.next)
        .onSubmit {
            focusedField = .password
        }
        .disabled(auth.isSubmitting)
    }

    private var passwordField: some View {
        AppSecureField(
            title: "Password",
            placeholder: "Enter you password",
            text: $password
        )
        .focused($focusedField, equals: .password)
        .submitLabel(.go)
        .onSubmit(handleSubmit)
        .disabled(auth.isSubmitting)
    }

    private var footer: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Don't have an account?")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            NavigationLink {
                SignUpView()
            } label: {
                Text("Create account")
                    .font(AppTypography.bodyStrong)
                    .foregroundStyle(AppColors.primaryAction)
                    .frame(minHeight: AppLayout.minimumControlHeight)
            }
            .disabled(auth.isSubmitting)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var auth = AuthViewModel()

    NavigationStack {
        SignInView()
    }
    .environment(auth)
}
