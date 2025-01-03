import SwiftUI

// MARK: - Toast
public struct Toast: Identifiable, Equatable {
    public let id = UUID()
    let message: String
    let duration: TimeInterval
    let icon: Image?

    public init(message: String, duration: TimeInterval = 2.0, icon: Image? = nil) {
        self.message = message
        self.duration = duration
        self.icon = icon
    }

    public static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - ToastManager
@MainActor
public class ToastManager: ObservableObject {
    @Published public private(set) var toasts: [Toast] = []
    private var tasks: [UUID: Task<Void, Never>] = [:]

    public init() {}

    public func show(_ toast: Toast) {
        withAnimation {
            toasts.append(toast)
        }

        // Cancel any existing task for this toast
        tasks[toast.id]?.cancel()

        // Create a new task for auto-hiding
        let task = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
            self?.hide(toast)
        }
        tasks[toast.id] = task
    }

    public func hide(_ toast: Toast) {
        // Cancel and remove the task
        tasks[toast.id]?.cancel()
        tasks[toast.id] = nil

        withAnimation {
            toasts.removeAll { $0.id == toast.id }
        }
    }

    deinit {
        // Cancel all pending tasks
        for task in tasks.values {
            task.cancel()
        }
    }
}
