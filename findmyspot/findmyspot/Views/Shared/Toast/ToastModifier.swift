//
//  ToastModifier.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.09.2026.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Environment(UserNotifier.self) private var notifier

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast = notifier.toast {
                VStack {
                    Spacer()

                    ToastView(toast: toast)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 24)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                }
                .zIndex(999)
            }
        }
        .animation(
            .spring(response: 0.35, dampingFraction: 0.85),
            value: notifier.toast
        )
    }
}

extension View {
    func toastOverlay() -> some View {
        modifier(ToastModifier())
    }
}
