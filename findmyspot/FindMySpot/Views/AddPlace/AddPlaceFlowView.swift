//
//  AddPlaceFlowView.swift
//  FindMySpot
//

import MapKit
import SwiftUI

struct AddPlaceFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserNotifier.self) private var notifier
    @State private var viewModel = AddPlaceViewModel()
    @State private var step = 0

    var body: some View {
        VStack(spacing: 0) {
            AddPlaceHeader(step: step, onBack: goBack, onCancel: dismiss.callAsFunction)

            ScrollView {
                Group {
                    switch step {
                    case 0:
                        AddPlaceIdeaStep(viewModel: viewModel)
                    case 1:
                        AddPlaceDetailsStep(viewModel: viewModel)
                    default:
                        AddPlaceReviewStep(viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 22)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)

            AddPlacePrimaryButton(
                title: buttonTitle,
                isLoading: viewModel.isSubmitting,
                isDisabled: step == 0 && !viewModel.canContinueFromIdea,
                action: advance
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(AppColors.background)
        }
        .background(AppColors.background.ignoresSafeArea())
        .foregroundStyle(AppColors.textPrimary)
        .alert(
            "Ort konnte nicht hinzugefügt werden",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Bitte versuche es erneut.")
        }
    }

    private var buttonTitle: String {
        switch step {
        case 0: "Weiter zur Ausstattung"
        case 1: "Weiter zur Prüfung"
        default: "Ort hinzufügen"
        }
    }

    private func goBack() {
        if step == 0 {
            dismiss()
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                step -= 1
            }
        }
    }

    private func advance() {
        guard step < 2 else {
            Task {
                if await viewModel.submit() {
                    notifier.success("Ort wurde hinzugefügt.")
                    dismiss()
                }
            }
            return
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            step += 1
        }
    }
}

private struct AddPlaceHeader: View {
    let step: Int
    let onBack: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 42, height: 42)
                        .background(AppColors.elevatedBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.surfaceSecondary, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Text("Ort hinzufügen · \(step + 1) von 3")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()

                Button("Abbrechen", action: onCancel)
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.plain)
            }

            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(index <= step ? AddPlaceStyle.accent : AppColors.surfaceSecondary)
                        .frame(height: 4)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 14)
        .background(AppColors.background)
    }
}

private struct AddPlaceIdeaStep: View {
    @Bindable var viewModel: AddPlaceViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AddPlaceTitle(
                eyebrow: "01 · DIE IDEE",
                title: "Ort hinzufügen",
                subtitle: "Teile einen öffentlich zugänglichen Spot."
            )

            AddPlaceTextField(
                label: "Name des Ortes",
                placeholder: "z. B. Meine Lieblingsbank",
                text: $viewModel.name
            )

            AddPlaceTextField(
                label: "Adresse / Lagebeschreibung",
                placeholder: "Strasse oder genauer Hinweis",
                text: $viewModel.addressDescription
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Was macht den Ort besonders?")
                    .font(.caption.weight(.semibold))

                ZStack(alignment: .topLeading) {
                    if viewModel.details.isEmpty {
                        Text("Beschreibe deinen Spot …")
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 15)
                    }

                    TextEditor(text: $viewModel.details)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                        .frame(minHeight: 112)
                        .foregroundStyle(AppColors.textPrimary)
                }
                .background(AppColors.elevatedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppColors.surfaceSecondary, lineWidth: 1)
                }
            }
        }
    }
}

private struct AddPlaceDetailsStep: View {
    @Bindable var viewModel: AddPlaceViewModel
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.4250, longitude: 9.3770),
            span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
        )
    )

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            AddPlaceTitle(
                eyebrow: "02 · DIE DETAILS",
                title: "Ausstattung & Lage"
            )

            ChipSection(title: "Aktivitäten") {
                ForEach(PlaceActivity.allCases) { activity in
                    SelectableChip(
                        title: activity.title,
                        isSelected: viewModel.selectedActivities.contains(activity)
                    ) {
                        viewModel.toggle(activity)
                    }
                }
            }

            ChipSection(title: "Eigenschaften") {
                ForEach(AddPlaceFeature.allCases) { feature in
                    SelectableChip(
                        title: feature.title,
                        isSelected: viewModel.selectedFeatures.contains(feature)
                    ) {
                        viewModel.toggle(feature)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Position auf der Karte")
                    .font(.title3.bold())

                Text("Tippe auf die Karte, um den Pin zu setzen.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                MapReader { proxy in
                    Map(position: $cameraPosition) {
                        Marker("Neuer Ort", coordinate: coordinate)
                            .tint(AddPlaceStyle.marker)
                    }
                    .mapStyle(.standard(pointsOfInterest: .excludingAll))
                    .onTapGesture { position in
                        guard let newCoordinate = proxy.convert(position, from: .local) else {
                            return
                        }
                        viewModel.updatePosition(
                            latitude: newCoordinate.latitude,
                            longitude: newCoordinate.longitude
                        )
                    }
                }
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Text(
                    "Position: \(viewModel.latitude.formatted(.number.precision(.fractionLength(4)))), \(viewModel.longitude.formatted(.number.precision(.fractionLength(4))))"
                )
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

private struct AddPlaceReviewStep: View {
    let viewModel: AddPlaceViewModel

    private var tags: [String] {
        viewModel.selectedActivities.map(\.title).sorted()
            + viewModel.selectedFeatures.map(\.title).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AddPlaceTitle(
                eyebrow: "03 · FAST GESCHAFFT",
                title: "Angaben prüfen"
            )

            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.name)
                    .font(.title3.bold())

                Text(viewModel.addressDescription)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Text(viewModel.details)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !tags.isEmpty {
                    AddPlaceFlowLayout(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(AppColors.elevatedBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.surfaceSecondary, lineWidth: 1)
                                }
                        }
                    }
                }

                Text(
                    "Position: \(viewModel.latitude.formatted(.number.precision(.fractionLength(4)))), \(viewModel.longitude.formatted(.number.precision(.fractionLength(4))))"
                )
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.top, 2)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.elevatedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(AppColors.surfaceSecondary, lineWidth: 1)
            }
        }
    }
}

private struct AddPlaceTitle: View {
    let eyebrow: String
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(eyebrow)
                .font(.caption2.weight(.semibold))
                .tracking(0.4)
                .foregroundStyle(AppColors.textSecondary)

            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

private struct AddPlaceTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal, 14)
                .frame(height: 54)
                .background(AppColors.elevatedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppColors.surfaceSecondary, lineWidth: 1)
                }
        }
    }
}

private struct ChipSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())

            AddPlaceFlowLayout(spacing: 8) {
                content
            }
        }
    }
}

private struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption2.bold())
                }

                Text(title)
                    .font(.subheadline)
            }
            .foregroundStyle(AppColors.textPrimary)
            .padding(.horizontal, 14)
            .frame(height: 42)
            .background(isSelected ? AddPlaceStyle.selectedChip : AppColors.elevatedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSelected ? AddPlaceStyle.selectedChipBorder : AppColors.surfaceSecondary,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

private struct AddPlacePrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.subheadline.bold())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(AddPlaceStyle.accent.opacity(isDisabled ? 0.45 : 1))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .disabled(isDisabled || isLoading)
    }
}

private struct AddPlaceFlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        layout(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let result = layout(proposal: proposal, subviews: subviews)

        for (index, point) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maximumWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentPosition = CGPoint.zero
        var lineHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentPosition.x > 0 && currentPosition.x + size.width > maximumWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(currentPosition)
            currentPosition.x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            contentWidth = max(contentWidth, currentPosition.x - spacing)
        }

        return (
            CGSize(width: contentWidth, height: currentPosition.y + lineHeight),
            positions
        )
    }
}

private enum AddPlaceStyle {
    static let accent = Color(red: 0.00, green: 0.37, blue: 0.31)
    static let selectedChip = Color(red: 0.88, green: 1.00, blue: 0.55)
    static let selectedChipBorder = Color(red: 0.68, green: 0.84, blue: 0.10)
    static let marker = Color(red: 0.65, green: 0.92, blue: 0.00)
}

#Preview {
    AddPlaceFlowView()
        .environment(UserNotifier())
}
