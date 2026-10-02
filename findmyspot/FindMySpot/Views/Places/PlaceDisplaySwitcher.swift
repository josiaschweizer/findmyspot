//
//  PlaceDisplaySwitcher.swift
//  FindMySpot
//
//  Created by josiaschweizer on 02.10.2026.
//

import SwiftUI

struct PlaceDisplaySwitcher: View {
    @Binding var selection: PlaceDisplayMode
    
    var body: some View {
        HStack(spacing: AppSpacing.xs){
            option(
                title: "Map",
                icon: AppIcons.places,
                mode: .map
            )
            
            option(
                title: "List",
                icon: AppIcons.list,
                mode: .list
            )
        }
        .padding(AppSpacing.xs)
        .background(
            AppColors.elevatedBackground,
            in: RoundedRectangle(cornerRadius: AppRadius.xl)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .strokeBorder(AppColors.borderDefault)
                .allowsHitTesting(false)
        }
    }
    
    private func option(
        title: String,
        icon: String,
        mode: PlaceDisplayMode
    ) -> some View {
        Button(
            action: {
                selection = mode
            },
            label: {
                Label(title, systemImage: icon)
                    .font(AppTypography.label)
                    .foregroundStyle(selection == mode ? AppColors.primary : AppColors.textSecondary)
                    .padding(.horizontal, AppSpacing.lg)
                    .frame(minHeight: AppLayout.minimumControlHeight)
                    .background(
                        selection == mode ? AppColors.selectedBackground : Color.clear,
                        in: RoundedRectangle(cornerRadius: AppRadius.md)
                    )
            }
        )
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == mode ? .isSelected : [])
    }
}
