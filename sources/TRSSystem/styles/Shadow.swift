import SwiftUI

struct ShadowViewModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager

    let baseSize: TRSSizes
    let x: CGFloat
    let y: CGFloat
    let colorElement: ThemeElement
    let opacity: Double

    func body(content: Content) -> some View {
        let resolvedColor = Color(themeManager.color(for: colorElement).color)
            .opacity(opacity)
        return content.shadow(baseSize: baseSize.value, color: resolvedColor, x: x, y: y)
    }
}

extension View {

    public func shadow(_ baseSize: TRSSizes, x: CGFloat = 0, y: CGFloat = 0,
                       colorElement: ThemeElement = .shadow,
                       opacity: Double = 1) -> some View {
        self.modifier(ShadowViewModifier(baseSize: baseSize, x: x, y: y, colorElement: colorElement, opacity: opacity))
    }

    public func shadow(baseSize: CGFloat, color: Color, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        shadow(color: color, radius: baseSize / 5, x: x, y: y)
            .shadow(color: color, radius: baseSize / 1.5, x: x, y: y)
            .shadow(color: color, radius: baseSize * 2, x: x, y: y)
    }
}
