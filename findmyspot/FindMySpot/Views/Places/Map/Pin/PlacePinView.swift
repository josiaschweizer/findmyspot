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

    private var iconSize: CGFloat {
        AppLayout.mapPinSize * 0.5
    }

    var body: some View {
        ZStack {
            style.color
            iconView
        }
        .frame(
            width: size,
            height: size
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
    private var iconView: some View {
        switch style.icon {
        case .system(let name):
            Image(systemName: name)
                .font(
                    .system(
                        size: size * style.iconScale,
                        weight: .semibold
                    )
                )
                .foregroundStyle(style.iconColor)
        case .asset(let name):
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(style.iconColor)
                .frame(height: size * style.iconScale)
        }
    }

}
