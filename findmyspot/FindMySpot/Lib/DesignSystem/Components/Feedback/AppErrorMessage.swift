//
//  AppErrorMessage.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppErrorMessage: View {
    let message: String

    var body: some View {
        Text(message)
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textDestructive)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}
