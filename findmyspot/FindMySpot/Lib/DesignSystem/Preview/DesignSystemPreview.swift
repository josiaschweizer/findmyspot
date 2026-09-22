//
//  DesignSystemPreview.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

#if DEBUG
    struct DesignSystemPreview: View {
        @State private var name = StringUtil.EMPTY
        @State private var invalidEmail = "hallo@"
        @State private var password = StringUtil.EMPTY
        @State private var search = StringUtil.EMPTY
        @State private var notes = StringUtil.EMPTY

        @State private var wifiSelect = true
        @State private var parkingSelected = false
        @State private var favoritesOnly = true
        @State private var notificationsEnabled = false

        @State private var lastAction = "Noch keine Aktion"

        var body: some View {
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.xxl
                ) {
                    header
                    tagsSection
                    buttonsSection
                    inputSection
                    selectionSection
                    surfaceSection
                    feedbackSection
                }
                .padding(AppSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(AppColors.background)
        }

        private var header: some View {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Design System")
                    .font(AppTypography.titleLarge)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Components and States for the Overview")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }

        private var tagsSection: some View {
            previewSection("Tags") {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), alignment: .leading),
                        GridItem(.flexible(), alignment: .leading),
                    ],
                    alignment: .leading,
                    spacing: AppSpacing.md
                ) {
                    AppTag("Neutral")
                    AppTag("Counter", variant: .highlighted)
                    AppTag("Successful", variant: .success)
                    AppTag("Warning", variant: .warning)
                    AppTag("Info", variant: .info)
                    AppTag("Error", variant: .error)
                }
            }
        }

        private var buttonsSection: some View {
            previewSection("Buttons") {
                AppButton("Primary") {
                    lastAction = "Primary pressed"
                }

                AppButton("Secondary", variant: .secondary) {
                    lastAction = "Secondary presssed"
                }

                AppButton("Destructive", variant: .destructive) {
                    lastAction = "Destructive pressed"
                }

                AppButton("Disabled", isEnabled: false) {}
                AppButton("Loading...", isLoading: true) {}

                HStack(spacing: AppSpacing.md) {
                    AppIconButton(
                        icon: AppIcons.favorite,
                        variant: .plain,
                        isEnabled: true
                    ) {
                        lastAction = "Favorites pressed"
                    }
                    .accessibilityLabel("Favorite")

                    AppIconButton(
                        icon: AppIcons.bookmark,
                        variant: .filled,
                        isEnabled: true
                    ) {
                        lastAction = "Bookmark pressed"
                    }
                    .accessibilityLabel("Bookmark")

                    AppIconButton(
                        icon: AppIcons.add,
                        variant: .filled,
                        isEnabled: false
                    ) {}
                    .accessibilityLabel("Add")
                }

                Text(lastAction)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }

        private var inputSection: some View {
            previewSection("Inputs") {
                AppTextField(
                    title: "Name",
                    placeholder: "Your name",
                    text: $name
                )

                AppTextField(
                    title: "E-Mail - Errorstate",
                    placeholder: "name@sample.ch",
                    text: $invalidEmail,
                    state: .error,
                    errorMessage: "Please enter a valid e-mail address"
                )

                AppSecureField(
                    title: "Password",
                    placeholder: "Your password",
                    text: $password
                )

                AppSearchField(
                    placeholder: "Search fields",
                    text: $search
                )

                AppTextArea(
                    title: "Note",
                    placeholder: "What do you wanna remember",
                    text: $notes
                )
            }
        }

        private var selectionSection: some View {
            previewSection("Selection") {
                HStack(spacing: AppSpacing.sm) {
                    AppChoice(
                        title: "WLAN",
                        isSelected: wifiSelect
                    ) {
                        wifiSelect.toggle()
                    }

                    AppChoice(
                        title: "Parking sppace",
                        isSelected: parkingSelected
                    ) {
                        parkingSelected.toggle()
                    }
                }

                AppSwitch(
                    title: "Only favorites",
                    isOn: $favoritesOnly
                )

                AppSwitch(title: "Messages", isOn: $notificationsEnabled)
            }
        }

        private var surfaceSection: some View {
            previewSection("Card and Diver") {
                AppCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.md
                    ) {
                        Text("A place at the lake")
                            .font(AppTypography.titleSmall)
                            .foregroundStyle(AppColors.textPrimary)

                        Text("A quiet place for your next break")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)

                        AppDivider()

                        HStack(spacing: AppSpacing.sm) {
                            AppTag("Nature")
                            AppTag("Hit", variant: .highlighted)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }

        private var feedbackSection: some View {
            previewSection("Feedback") {
                AppErrorMessage(
                    message: "There appeared an error during save"
                )

                AppCard {
                    AppEmptyState(
                        icon: AppIcons.favorite,
                        title: "No favorites",
                        message:
                            "Mark a place with a heart so that it appears here"
                    )
                }

                AppCard {
                    AppEmptyState(
                        icon: AppIcons.search,
                        title: "No matching places",
                        message: "Remove a filter and try again.",
                        actionTitle: "Reset Filter"
                    ) {
                        wifiSelect = false
                        parkingSelected = false
                        search = StringUtil.EMPTY
                        lastAction = "Filters reset"
                    }
                }
            }
        }

        private func previewSection<Content: View>(
            _ title: String,
            @ViewBuilder content: () -> Content
        ) -> some View {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text(title)
                    .font(AppTypography.titleMedium)
                    .foregroundStyle(AppColors.textPrimary)

                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    #Preview("Design System - Light") {
        DesignSystemPreview()
            .preferredColorScheme(.light)
    }

    #Preview("Design System - Dark") {
        DesignSystemPreview()
            .preferredColorScheme(.dark)
    }

#endif
