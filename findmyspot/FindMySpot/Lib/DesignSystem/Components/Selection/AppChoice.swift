//
//  AppChoice.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppChoice: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        SelectableChip(
            title: title,
            isSelected: isSelected,
            action: action
        )
    }
}
