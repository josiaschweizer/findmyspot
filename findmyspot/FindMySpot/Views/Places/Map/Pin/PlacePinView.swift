//
//  PlacePinView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 03.10.2026.
//

import SwiftUI

struct PlacePinView: View {
    let style: PlacePinStyle
    let isSelected: Bool

    private var size: CGFloat {
        AppLayout.mapPinSize
    }
    private var doubleIconSize: CGFloat {
        AppLayout.mapPinSize * 1.2
    }
    
    private var iconSize: CGFloat {
        AppLayout.mapPinSize * 0.8
    }

    var body: some View {
        ZStack {
            background
            icons
        }
        .frame(
            width: style == .both ? doubleIconSize : size,
            height: style == .both ? doubleIconSize : size
        )
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(
                    PlacePinConstants.borderColor,
                    lineWidth: PlacePinConstants.borderWidth
                )
        )
        .scaleEffect(isSelected ? PlacePinConstants.selectedScale : 1)
        .animation(
            PlacePinConstants.selectionAnimation,
            value: isSelected
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(style.accessibilityText)
    }

    @ViewBuilder
    private var background: some View {
        if style == .both {
            HStack(spacing: 0) {
                PlacePinStyle.favorite.color
                PlacePinStyle.bookmark.color
            }
        } else {
            style.color
        }
    }

    @ViewBuilder
    private var icons: some View {
        if style == .both {
            HStack(spacing: 0) {
                Image(systemName: AppIcons.favoriteSelected)
                    .foregroundStyle(PlacePinStyle.favorite.iconColor)
                    .frame(width: size / 2)
                Image(systemName: AppIcons.bookmarkSelected)
                    .foregroundStyle(PlacePinStyle.bookmark.iconColor)
                    .frame(width: size / 2)
            }
            .font(PlacePinConstants.splitIconFont)
        } else {
            Image(systemName: style.icon)
                .font(PlacePinConstants.iconFont)
                .foregroundStyle(style.iconColor)
                .frame(width: iconSize, height: iconSize)
        }
    }
}
