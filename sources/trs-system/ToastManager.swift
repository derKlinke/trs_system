//
//  ToastManager.swift
//  trs-system
//
//  Created by Fabian S. Klinke on 2024-07-30.
//

import SwiftUI

// MARK: - ToastManager
public class ToastManager: ObservableObject {
    @Published public var toasts: [Toast] = []

    public init() {}

    public func show(_ toast: Toast) {
        withAnimation {
            toasts.append(toast)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
            self.hide(toast)
        }
    }

    public func hide(_ toast: Toast) {
        withAnimation {
            toasts.removeAll { $0.id == toast.id }
        }
    }
}

// MARK: - Toast
public struct Toast: Identifiable {
    public let id = UUID()
    let message: String
    let duration: TimeInterval
    let icon: Image?

    public init(message: String, duration: TimeInterval, icon: Image? = nil) {
        self.message = message
        self.duration = duration
        self.icon = icon
    }
}
