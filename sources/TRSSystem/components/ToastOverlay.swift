import SwiftUI

// MARK: - ToastOverlay
public struct ToastOverlay: View {
    @EnvironmentObject var toastManager: ToastManager

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ForEach(toastManager.toasts) { toast in
                ToastView(toast: toast)
                    .animation(.easeInOut(duration: 0.3))
            }
            .padding(.bottom, .large)
        }
    }
}

// MARK: - ToastView
struct ToastView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let toast: Toast

    var body: some View {
        HStack {
            if let icon = toast.icon {
                icon
                    .resizable()
                    .frame(square: .medium)
            }

            Text(toast.message)
                .font(trs: .mono)
        }
        .padding(.tiny)
        .padding(.horizontal, .small)
        .background(Color(themeManager.color(for: .secondaryBackground).color))
        .borderClip(.tiny)
        .padding(.medium)
    }
}
