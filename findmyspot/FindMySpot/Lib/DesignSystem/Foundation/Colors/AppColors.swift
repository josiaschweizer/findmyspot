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

    // Status
    static let statusSuccess = Color("StatusSuccess")
    static let statusSuccessBackground = Color("StatusSuccessBackground")

    static let statusWarning = Color("StatusWarning")
    static let statusWarningBackground = Color("StatusWarningBackground")

    static let statusInfo = Color("StatusInfo")
    static let statusInfoBackground = Color("StatusInfoBackground")

    static let statusErrorBackground = Color("StatusErrorBackground")

}

extension AppColors {

    static let primary = brand900
    static let primaryDark = brand950

    static let primaryAction = brand900
    static let primaryActionPressed = brand950

    static let focus = brand800

    static let selectedBackground = accentLimeSoft
    static let highliehgt = accentLime

    static let background = surfaceBase
    static let elevatedBackground = surfaceWhite

    static let separator = borderDefault

    // Status
    static let success = statusSuccess
    static let successBackground = statusSuccessBackground

    static let warning = statusWarning
    static let warningBackground = statusWarningBackground

    static let info = statusInfo
    static let infoBackground = statusInfoBackground

    static let error = textDestructive
    static let errorBackground = statusErrorBackground

}
