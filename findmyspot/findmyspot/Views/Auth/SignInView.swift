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

    var body: some View {
        Form {
            Section {
                TextField("Email address", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Password", text: $password)
                    .textContentType(.password)
            }

            if let errorMessage = auth.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button {
                    Task {
                        await auth.signIn(
                            email: email,
                            password: password
                        )
                    }
                } label: {
                    HStack {
                        if auth.isSubmitting {
                            ProgressView()
                        }

                        Text("Sign In")
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(
                    email.isEmpty || password.isEmpty || auth.isSubmitting
                )
            }

            Section {
                NavigationLink("Create an account") {
                    SignUpView()
                }
            }
        }
        .navigationTitle("Sign in")
    }
}

#Preview {
    NavigationStack{
        SignInView()
    }
    .environment(AuthViewModel())
}
