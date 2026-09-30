//
//  Toast.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.09.2026.
//

import Foundation

struct Toast: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
}

enum ToastType {
    case success
    case error
    case info
}
