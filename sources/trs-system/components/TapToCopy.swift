import SwiftUI

public struct TapToCopy<Content>: View where Content: View {
    let content: Content
    let text: String
    
    @EnvironmentObject var toastManager: ToastManager

    public init(_ text: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.text = text
    }

    public var body: some View {
        HStack {
            content
        }
        .help("Double-click to copy")
        .onTapGesture(count: 2) {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
            
            TRSSoundManager.shared.play(sound: .copy)
            
            // TODO: display a little toast message
            toastManager.show(Toast(message: "Copied to clipboard", duration: 1, icon: Image(systemName: "doc.on.clipboard")))
        }
    }
}
