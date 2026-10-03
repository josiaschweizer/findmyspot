//
//  PlacePinConstants.swift
//  FindMySpot
//
//  Created by josiaschweizer on 03.10.2026.
//

import SwiftUI

enum PlacePinConstants {
    static let iconFont = Font.system(size: 18, weight: .semibold)
    static let splitIconFont = Font.system(size: 14, weight: .semibold)

    static let borderColor: Color = .white
    static let borderWidth: CGFloat = 2

    static let selectedScale: CGFloat = 1.25
    static let selectionAnimation = Animation.spring(duration: 0.2)
}
