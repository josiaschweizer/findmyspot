//
//  AuthBackground.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthBackground: View{
    var body: some View{
        ZStack{
            Color(.systemGroupedBackground)
            
            Circle()
                .fill(AppColors.primary.opacity(0.08))
                .frame(width: 320, height: 320)
                .offset(x: 160, y: -280)
            
            Circle()
                .fill(AppColors.primary.opacity(0.06))
                .frame(width: 260, height: 260)
                .offset(x: -150, y: 320)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AuthBackground()
}
