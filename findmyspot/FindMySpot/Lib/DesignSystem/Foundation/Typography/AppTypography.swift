//
//  AppTypography.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

enum AppTypography {
    
    // Titles
    static let titleLarge = Font.system(
        size: 28,
        weight: .bold
    )
    
    static let titleMedium = Font.system(
        size: 19,
        weight: .semibold
    )
    
    static let titleSmall = Font.system(
        size: 17,
        weight: .semibold 
    )
    
    // Body
    static let body = Font.system(
        size: 16,
        weight: .regular
    )
    
    static let bodyStrong = Font.system(
        size: 16,
        weight: .semibold
    )
    
    // Label
    static let label = Font.system(
        size: 14,
        weight: .medium
    )
    
    static let caption = Font.system(
        size: 12,
        weight: .regular 
    )
    
}
