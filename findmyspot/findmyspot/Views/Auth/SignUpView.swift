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

    private var showPasswordMismatch: Bool {
        !confirmPassword.isEmpty && !passwordsMatch
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
                email: normalizedEmail,
                password: password,
                displayName: normalizedDisplayName
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

                    AppCard {
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.lg
                        ) {
                            displayNameField
                            emailField
                            passwordField
                            confirmPasswordField

                            if let errorMessage = auth.errorMessage {
                                AppErrorMessage(message: errorMessage)
                            }

                            AppButton(
                                "Create Account",
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
                .padding(.top, AppSpacing.xxl)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var displayNameField: some View {
        AppTextField(
            title: "Display name",
            placeholder: "Your name",
            text: $displayName
        )
        .focused($focusedField, equals: .displayName)
        .textContentType(.nickname)
        .textInputAutocapitalization(.words)
        .autocorrectionDisabled()
        .submitLabel(.next)
        .onSubmit {
            focusedField = .email
        }
        .disabled(auth.isSubmitting)
    }

    private var emailField: some View {
        AppTextField(
            title: "Email address",
            placeholder: "name@example.com",
            text: $email
        )
        .focused($focusedField, equals: .email)
        .textContentType(.emailAddress)
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
            placeholder: "Create a password",
            text: $password
        )
        .focused($focusedField, equals: .password)
        .textContentType(.newPassword)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .confirmPassword
        }
        .disabled(auth.isSubmitting)
    }

    private var confirmPasswordField: some View {
        AppSecureField(
            title: "Confirm password",
            placeholder: "Enter you password again",
            text: $confirmPassword,
            state: showPasswordMismatch ? .error : .normal,
            errorMessage: showPasswordMismatch ? "Passwords do not match." : nil
        )
        .focused($focusedField, equals: .confirmPassword)
        .textContentType(.newPassword)
        .submitLabel(.go)
        .onSubmit {
            handleSubmit()
        }
        .disabled(auth.isSubmitting)
    }

    private var footer: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Already have an account?")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            Button {
                dismiss()
            } label: {
                Text("Sign In")
                    .font(AppTypography.bodyStrong)
                    .foregroundStyle(AppColors.primaryAction)
                    .frame(minHeight: AppLayout.minimumControlHeight)
            }
            .buttonStyle(.plain)
            .disabled(auth.isSubmitting)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var auth = AuthViewModel()

    NavigationStack {
        SignUpView()
    }
    .environment(auth)
}
