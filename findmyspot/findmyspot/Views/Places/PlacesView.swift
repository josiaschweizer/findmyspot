//
//  PlacesView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import MapKit
import SwiftUI

@MainActor
struct PlacesView: View {
    @EnvironmentObject private var interactions: PlaceStore

    @StateObject private var viewModel = PlacesViewModel()
    @StateObject private var filterViewModel = PlaceFilterViewModel()
    @StateObject private var locationPermission = LocationPermissionManager()

    @Namespace private var mapScope

    @State private var displayMode: PlaceDisplayMode = .map
    @State private var selectedPlaceId: UUID?
    @State private var detailPlaceId: UUID?
    @State private var showFilters = false
    @State private var isAddingPlace = false

    @State private var searchText = StringUtil.EMPTY
    @FocusState private var isSearchFieldFocused: Bool

    @AppStorage("places.listLayout")
    private var listLayout: PlaceListLayout = .compact

    @State private var sortOrder: PlaceSortOrder = .nameAscending

    private var displayedPlaces: [Place] {
        viewModel.places.map {
            interactions.applyingState(to: $0)
        }
    }

    private var selectedPlace: Place? {
        displayedPlaces.first { $0.id == selectedPlaceId }
    }

    var body: some View {
        ZStack(alignment: .top) {
            PlacesMapView(
                places: displayedPlaces,
                mapScope: mapScope,
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
                    places: displayedPlaces,
                    userLocation: locationPermission.location,
                    sortOrder: sortOrder,
                    listLayout: $listLayout,

                    onSelect: { placeId in
                        isSearchFieldFocused = false
                        detailPlaceId = placeId
                    }
                )
                .transition(
                    .move(edge: .trailing)
                        .combined(with: .opacity)
                )
                .zIndex(1)
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: displayMode
        )
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
                },
                sortOrder: $sortOrder,
                showViewSettingMenu: displayMode == .list,
                canSortByDistance: locationPermission.location != nil,
                listLayout: $listLayout
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
        .mapScope(mapScope)
        .onAppear {
            locationPermission.requestIfNeeded()
        }
        .onDisappear {
            locationPermission.stop()
        }
        .onChange(of: locationPermission.location == nil) { _, unavailable in
            if unavailable && sortOrder == .nearest {
                sortOrder = .nameAscending
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .task(id: searchText) {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else {
                return
            }
            await viewModel.search(searchText)
        }
        .navigationDestination(item: $detailPlaceId) { placeId in
            if let place = viewModel.places.first(where: { $0.id == placeId }) {
                PlaceDetailView(place: place)
            }
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
        .fullScreenCover(isPresented: $isAddingPlace) {
            AddPlaceFlowView {
                await viewModel.refresh()
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
                },
                onOpenDetail: {
                    detailPlaceId = place.id
                },
                onBookmarkChanged: {
                    viewModel.setBookmark($0, for: place.id)
                },
                onFavoriteChanged: {
                    viewModel.setFavorite($0, for: place.id)
                }
            )
            .id(place.id)
        } else {
            PlaceDisplaySwitcher(selection: $displayMode)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    VStack(spacing: AppSpacing.md) {
                        if displayMode == .map {

                            MapUserLocationButton(scope: mapScope)
                                .frame(width: 44, height: 44)
                                .tint(AppColors.primary)
                                .background(
                                    AppColors.elevatedBackground,
                                    in: Circle()
                                )
                                .appPressEffect()

                            AppIconButton(
                                icon: AppIcons.add,
                                variant: .circle,
                                isEnabled: true,
                                action: openCreatePlace
                            )
                            .tint(AppColors.primary)
                            .accessibilityLabel("Create new place")
                        }
                    }
                }
        }
    }

    private func openCreatePlace() {
        isSearchFieldFocused = false
        isAddingPlace = true
    }
}

#Preview {
    PlacesView()
        .environment(UserNotifier())
        .environmentObject(PlaceStore())
}
