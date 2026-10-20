//
//  AddPlaceFlowView.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserNotifier.self) private var notifier

    @State private var viewModel = AddPlaceViewModel()
    @State private var step = 0

    let onPlaceCreated: () async -> Void

    init(onPlaceCreated: @escaping () async -> Void = {}) {
        self.onPlaceCreated = onPlaceCreated
    }

    var body: some View {
        VStack(spacing: 0) {
            AddPlaceHeader(
                step: step,
                onBack: goBack,
                onCancel: dismiss.callAsFunction
            )

            ScrollView {
                stepContent
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.lg)
            }
            .scrollDismissesKeyboard(.interactively)

            AddPlacePrimaryButton(
                title: buttonTitle,
                isLoading: viewModel.isSubmitting,
                isDisabled: step == 0 && !viewModel.canContinueFromIdea,
                action: advance
            )
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.background)
        }
        .background(AppColors.background.ignoresSafeArea())
        .foregroundStyle(AppColors.textPrimary)
        .alert(
            "Ort konnte nicht hinzugefügt werden",
            isPresented: errorBinding
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Bitte versuche es erneut.")
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 0:
            AddPlaceIdeaStep(viewModel: viewModel)
        case 1:
            AddPlaceDetailsStep(viewModel: viewModel)
        default:
            AddPlaceReviewStep(viewModel: viewModel)
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )
    }

    private var buttonTitle: String {
        switch step {
        case 0: "Weiter zur Ausstattung"
        case 1: "Weiter zur Prüfung"
        default: "Ort hinzufügen"
        }
    }

    private func goBack() {
        guard step > 0 else {
            dismiss()
            return
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            step -= 1
        }
    }

    private func advance() {
        guard step == 2 else {
            withAnimation(.easeInOut(duration: 0.2)) {
                step += 1
            }
            return
        }

        Task {
            guard await viewModel.submit() else {
                return
            }

            await onPlaceCreated()
            notifier.success("Ort wurde hinzugefügt.")
            dismiss()
        }
    }
}

#Preview {
    AddPlaceFlowView()
        .environment(UserNotifier())
}
