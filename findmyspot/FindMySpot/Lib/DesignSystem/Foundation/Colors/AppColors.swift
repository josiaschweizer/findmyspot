//
//  AppColors.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.09.2026.
//

import SwiftUI

enum AppColors {
    
    // Brand
    static let brand950 = Color("Brand950")
    static let brand900 = Color("Brand900")
    static let brand800 = Color("Brand800")
    
    // Accent
    static let accentLime = Color("AccentLime")
    static let accentLimeSoft = Color("AccentLimeSoft")
    static let accentLeaf = Color("AccentLeaf")
    
    // Text
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textDestructive = Color("TextDestructive")
    
    // Surface
    static let surfaceBase = Color("SurfaceBase")
    static let surfaceSecondary = Color("SurfaceSecondary")
    static let surfaceWhite = Color("SurfaceWhite")
    static let surfaceMapCanvas = Color("SurfaceMapCanvas")
    
    // Border
    static let borderDefault = Color("BorderDefault")
    
}

extension AppColors {
    
    static let primaryAction = brand900
    static let primaryActionPressed = brand950
    
    static let focus = brand800
    
    static let selectedBackground = accentLimeSoft
    static let highliehgt = accentLime
    
    static let background = surfaceBase
    static let elevatedBackground = surfaceWhite
    
    static let separator = borderDefault 
    
}
