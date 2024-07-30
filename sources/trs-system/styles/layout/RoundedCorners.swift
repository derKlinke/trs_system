import Foundation
import SwiftUI

// MARK: - RoundedTRSRectangle
public struct RoundedTRSRectangle: Shape {
    let size: TRSSizes

    public init(size: TRSSizes) {
        self.size = size
    }

    public func path(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: size.value)
    }
}

// MARK: - RoundedClip
public struct RoundedClip: ViewModifier {
    let size: TRSSizes

    public init(size: TRSSizes) {
        self.size = size
    }

    public func body(content: Content) -> some View {
        content.clipShape(RoundedTRSRectangle(size: size))
    }
}

extension View {
    public func roundedClip(_ size: TRSSizes = .medium) -> some View {
        self.modifier(RoundedClip(size: size))
    }

    public func borderClip(_ size: TRSSizes = .tiny) -> some View {
        self.roundedClip(size)
            .overlay {
                RoundedTRSRectangle(size: size).stroke(DynamicTRSColor.separator.color,
                                                       lineWidth: size.value / 10)
            }
    }
}
