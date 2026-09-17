//
//  AuthValidationRow.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthValidationRow: View{
    let text: String
    let isValid: Bool
    
    var body: some View{
        HStack(spacing: 10){
            Image(
                systemName: isValid ? "checkmark.circle.fill" : "circle"
            )
            .foregroundStyle(isValid ? .green : .secondary)
            
            Text(text).font(.subheadline)
            
            Spacer()
        }
    }
}
