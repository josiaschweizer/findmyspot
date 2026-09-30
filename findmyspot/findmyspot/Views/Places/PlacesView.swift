//
//  PlacesView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

@MainActor
struct PlacesView: View {
    @StateObject private var viewModel: PlacesViewModel
    @StateObject private var filterViewModel: PlaceFilterViewModel

    @State private var showFilters = false
    @State private var appliedFilters = PlaceFilter()

    @State private var searchText: String
    @FocusState private var isSearchFieldFocused: Bool

    init() {
        let repository = PlaceRepository()

        _viewModel = StateObject(
            wrappedValue: PlacesViewModel(
                fetchPlaces: {
                    try await repository.getAll()
                }
            )
        )
        _filterViewModel = StateObject(
            wrappedValue: PlaceFilterViewModel()
        )

        searchText = StringUtil.EMPTY
    }

    var body: some View {
        ZStack(alignment: .top) {
            PlacesMapView(viewModel: viewModel)
                .ignoresSafeArea()
                .simultaneousGesture(
                    TapGesture().onEnded {
                        isSearchFieldFocused = false
                    }
                )

            HStack(spacing: AppSpacing.lg) {
                if viewModel.isLoading {
                    loadingCard
                } else {
                    AppCard {
                        HStack(spacing: AppSpacing.lg) {
                            Image(systemName: AppIcons.search)
                                .foregroundStyle(AppColors.primary)

                            TextField(
                                "Place or Properties...",
                                text: $searchText
                            )
                            .font(AppTypography.body)
                            .tint(AppColors.primary)
                            .submitLabel(.search)
                            .focused($isSearchFieldFocused)
                            .onSubmit {
                                isSearchFieldFocused = false
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    AppIconButton(
                        icon: AppIcons.filter,
                        isEnabled: true
                    ) {
                        isSearchFieldFocused = false
                        showFilters = true
                    }
                    .background(AppColors.elevatedBackground, in: Circle())
                    .accessibilityLabel("Open Filters")
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
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
                        selection: appliedFilters,
                        onApply: { selection in
                            appliedFilters = selection
                        }
                    )
                }
            }
            .task {
                await filterViewModel.loadIfNeeded()
            }
        }
    }

    private var loadingCard: some View {
        AppCard {
            HStack(spacing: AppSpacing.lg) {
                ProgressView()
                    .tint(AppColors.primary)

                Text("Loading places...")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
    }
}

#Preview {
    PlacesView()
}
