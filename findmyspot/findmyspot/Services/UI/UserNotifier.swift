//
//  UserNotifier.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.09.2026.
//

import Observation

@MainActor
@Observable
final class UserNotifier {
    var toast: Toast?

    func success(_ message: String) {
        show(message, type: .success)
    }

    func error(_ message: String) {
        show(message, type: .error)
    }

    func info(_ message: String) {
        show(message, type: .info)
    }

    func dismiss() {
        toast = nil
    }

    private func show(_ message: String, type: ToastType) {
        show(
            Toast(
                message: message,
                type: type
            )
        )
    }

    private func show(_ toast: Toast) {
        self.toast = toast

        Task {
            try? await Task.sleep(for: .seconds(2.5))

            if self.toast?.id == toast.id {
                self.toast = nil
            }
        }
    }
}
