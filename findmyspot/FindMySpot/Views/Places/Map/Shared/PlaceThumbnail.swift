//
//  PlaceThumbnail.swift
//  FindMySpot
//
//  Created by josiaschweizer on 22.10.2026.
//

import SwiftUI

struct PlaceThumbnail: View {
    let imageURL: URL?
    var size: CGFloat = AppLayout.thumbnailSize
    var cornerRadius: CGFloat = AppRadius.lg

    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(AppColors.borderDefault, lineWidth: 1)
        }
        .accessibilityHidden(true)
    }

    private var placeholder: some View {
        ZStack {
            AppColors.surfaceSecondary
            Image(systemName: AppIcons.places)
                .font(size < 56 ? AppTypography.body : AppTypography.titleLarge)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}
