//
//  SettingsView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.10.2026.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    @State private var viewModel = SettingsViewModel()
    @State private var isConfirmingSignOut = false
    @State private var isEditingName = false
    @State private var draftName = StringUtil.EMPTY
    @State private var didSaveFail = false

    @AppStorage(AppearancePreference.storageKey)
    private var appearance = AppearancePreference.system

    private let websiteURL = URL(string: "https://findmyspot.ch")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                header
                profileHeader

                if let errorMessage = viewModel.errorMessage {
                    AppErrorMessage(message: errorMessage)
                }

                profileSection
                locationSection
                appearanceSection
                accountSection
                aboutSection
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.refreshLocationStatus()
            }
        }
        .sheet(isPresented: $isEditingName) {
            editNameSheet
        }
        .alert("Log out?", isPresented: $isConfirmingSignOut) {
            Button("Cancel", role: .cancel) {}

            Button("Log out", role: .destructive) {
                Task {
                    await auth.signOut()
                }
            }
        } message: {
            Text(
                "You can sign in again at any time with your email and password."
            )
        }
    }

    private var header: some View {
        Text("Settings")
            .font(AppTypography.titleLarge)
            .foregroundStyle(AppColors.textPrimary)
            .padding(.top, AppSpacing.lg)
            .accessibilityAddTraits(.isHeader)
    }

    private var profileHeader: some View {
        HStack(spacing: AppSpacing.lg) {
            Text(initials)
                .font(AppTypography.titleLarge)
                .foregroundStyle(AppColors.textPrimary)
                .frame(
                    width: AppLayout.avatarSize,
                    height: AppLayout.avatarSize
                )
                .background(
                    AppColors.surfaceSecondary,
                    in: RoundedRectangle(cornerRadius: AppRadius.xxxl)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: AppRadius.xxxl)
                        .strokeBorder(AppColors.borderDefault)
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(
                    viewModel.profile == nil
                        ? "Display name" : viewModel.displayName
                )
                .font(AppTypography.titleMedium)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)

                Text(
                    viewModel.email.isEmpty
                        ? "name@example.com" : viewModel.email
                )
                .font(AppTypography.label)
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
                .truncationMode(.middle)

                if let createdAt = viewModel.profile?.createdAt {
                    AppTag(
                        "Member since \(createdAt.formatted(.dateTime.month(.wide).year()))"
                    )
                }
            }
        }
        .redacted(reason: viewModel.profile == nil ? .placeholder : [])
        .accessibilityElement(children: .combine)
    }

    private var initials: String {
        let words = viewModel.displayName.split(separator: " ")
        let letters = [words.first, words.count > 1 ? words.last : nil]
            .compactMap { $0?.first }

        return letters.isEmpty ? "?" : String(letters).uppercased()
    }

    private var profileSection: some View {
        SettingsSection("Your area") {
            Button {
                draftName = viewModel.displayName
                didSaveFail = false
                isEditingName = true
            } label: {
                SettingsRow(
                    icon: AppIcons.person,
                    title: "Edit profile",
                    showsChevron: true
                )
            }
            .buttonStyle(.plain)
            .disabled(viewModel.profile == nil)
        }
    }

    private var accountSection: some View {
        SettingsSection("Account", footer: auth.errorMessage) {
            Button {
                isConfirmingSignOut = true
            } label: {
                SettingsRow(
                    icon: AppIcons.signOut,
                    title: "Log out",
                    showsChevron: !auth.isSubmitting
                ) {
                    if auth.isSubmitting {
                        ProgressView()
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(auth.isSubmitting)
        }
    }

    private var locationSection: some View {
        SettingsSection(
            "Location",
            footer: viewModel.locationStatus.description
        ) {
            SettingsRow(icon: AppIcons.location, title: "Location access") {
                Text(viewModel.locationStatus.title)
                    .font(AppTypography.bodyStrong)
                    .foregroundStyle(viewModel.locationStatus.color)
            }

            if viewModel.locationStatus.canOpenSettings {
                Button {
                    openSystemSettings()
                } label: {
                    SettingsRow(
                        icon: AppIcons.settings,
                        title: "Open iOS Settings"
                    ) {
                        externalLinkIcon
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var appearanceSection: some View {
        SettingsSection("Appearance") {
            SettingsRow(icon: AppIcons.appearance, title: "Theme") {
                Picker("Theme", selection: $appearance) {
                    ForEach(AppearancePreference.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(AppColors.textSecondary)
            }
        }
    }

    private var aboutSection: some View {
        SettingsSection("About") {
            SettingsRow(
                icon: AppIcons.info,
                title: "Version",
                value: viewModel.appVersion
            )

            Button {
                openURL(websiteURL)
            } label: {
                SettingsRow(icon: AppIcons.website, title: "findmyspot.ch") {
                    externalLinkIcon
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var signOutSection: some View {
        Section {
            Button {
                isConfirmingSignOut = true
            } label: {
                SettingsRow(
                    icon: AppIcons.signOut,
                    title: "Sign out",
                    isDestructive: true
                ) {
                    if auth.isSubmitting {
                        ProgressView()
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(auth.isSubmitting)
        } footer: {
            if let errorMessage = auth.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(AppColors.error)
            }
        }
    }

    private var editNameSheet: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                AppTextField(
                    title: "Display name",
                    placeholder: "Your name",
                    text: $draftName,
                    state: nameErrorMessage == nil ? .normal : .error,
                    errorMessage: nameErrorMessage
                )
                .textContentType(.nickname)
                .onChange(of: draftName) {
                    didSaveFail = false
                }

                AppButton(
                    "Save",
                    isEnabled: viewModel.canSave(draftName),
                    isLoading: viewModel.isSaving
                ) {
                    saveDisplayName()
                }

                Spacer()
            }
            .padding(AppSpacing.lg)
            .background(AppColors.background)
            .navigationTitle("Display name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isEditingName = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .interactiveDismissDisabled(viewModel.isSaving)
    }

    private var nameErrorMessage: String? {
        let max = SettingsViewModel.displayNameMaxLength

        if draftName.count > max {
            return "Use at most \(max) characters."
        } else if didSaveFail {
            return "Your display name couldn't be saved. Please try again."
        }

        return nil
    }

    private var externalLinkIcon: some View {
        Image(systemName: AppIcons.externalLink)
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textSecondary)
    }

    private func saveDisplayName() {
        Task {
            if await viewModel.saveDisplayName(draftName) {
                isEditingName = false
            } else {
                didSaveFail = true
            }
        }
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(url)
    }
}
