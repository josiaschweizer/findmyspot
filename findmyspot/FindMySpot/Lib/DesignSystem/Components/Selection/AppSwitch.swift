//
//  AppSwitch.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppSwitch: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
        }
        .tint(AppColors.primaryAction)
        .frame(minHeight: AppLayout.minimumControlHeight)
    }
}
