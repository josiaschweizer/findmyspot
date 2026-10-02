//
//  PlacesView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

@MainActor
struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @StateObject private var filterViewModel = PlaceFilterViewModel()

    @State private var displayMode: PlaceDisplayMode = .map
    @State private var selectedPlaceId: UUID?
    @State private var showFilters = false

    @State private var searchText = StringUtil.EMPTY
    @FocusState private var isSearchFieldFocused: Bool

    private var selectedPlace: Place? {
        viewModel.places.first { $0.id == selectedPlaceId }
    }

    var body: some View {
        ZStack(alignment: .top) {
            PlacesMapView(
                viewModel: viewModel,
                selectedPlaceId: $selectedPlaceId
            )
            .ignoresSafeArea(.container, edges: .top)
            .opacity(displayMode == .map ? 1 : 0)
            .allowsHitTesting(displayMode == .map)
            .accessibilityHidden(displayMode != .map)
            .simultaneousGesture(
                TapGesture().onEnded {
                    isSearchFieldFocused = false
                }
            )

            if displayMode == .list {
                PlacesListView(
                    places: viewModel.places,
                    onSelect: { placeId in
                        isSearchFieldFocused = false
                        selectedPlaceId = placeId
                    }
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .safeAreaInset(edge: .top, spacing: 0) {
            PlaceFilterBar(
                isLoading: viewModel.isLoading,
                searchText: $searchText,
                isSearchFieldFocused: $isSearchFieldFocused,
                onOpenFilters: {
                    showFilters = true
                }
            )
            .background {
                if displayMode == .list {
                    AppColors.background
                        .ignoresSafeArea(.container, edges: .top)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomContent.padding(AppSpacing.lg)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .sheet(isPresented: $showFilters) {
            Group {
                if filterViewModel.isLoading {
                    ProgressView("Loading filter options...")
                        .font(AppTypography.body)
                        .tint(AppColors.primary)
                } else if let message = filterViewModel.errorMessage {
                    AppCard {
                        VStack(spacing: AppSpacing.lg) {
                            AppErrorMessage(message: message)

                            AppButton(
                                "Try again",
                                action: {
                                    Task {
                                        await filterViewModel.loadIfNeeded()
                                    }
                                }
                            )
                        }
                    }
                    .padding(AppSpacing.lg)
                } else {
                    PlacesFilterView(
                        purposes: filterViewModel.purposes,
                        features: filterViewModel.features,
                        selection: viewModel.filter,
                        onApply: { newFilter in
                            Task {
                                await viewModel.apply(newFilter)
                            }
                        }
                    )
                }
            }
            .task {
                await filterViewModel.loadIfNeeded()
            }
        }
    }

    @ViewBuilder
    private var bottomContent: some View {
        if let place = selectedPlace {
            PlacePreviewContainer(
                place: place,
                onClose: {
                    selectedPlaceId = nil
                }
            )
            .id(place.id)
        } else {
            PlaceDisplaySwitcher(selection: $displayMode)
        }
    }
}

#Preview {
    PlacesView()
}
