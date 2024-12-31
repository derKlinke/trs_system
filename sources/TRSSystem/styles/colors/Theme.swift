// MARK: - Theme
public struct Theme: Sendable {
    public let name: String
    private var colors: [ThemeElement: TRSColor]

    public init(name: String, colorMapping: [ThemeElement: TRSColor]) {
        self.name = name
        self.colors = colorMapping
    }

    /// Retrieves the color for a given `ThemeElement`.
    public func color(for element: ThemeElement) -> TRSColor {
        colors[element] ?? TRSBaseColorDefinitions.white
    }
}

// MARK: - Predefined Themes

public extension Theme {
    static let light = Theme(name: "Light", colorMapping: [
        .background: TRSBaseColorDefinitions.white,
        .text: TRSBaseColorDefinitions.text,
        .headline: TRSBaseColorDefinitions.primary,
        .accent: TRSBaseColorDefinitions.accent,
        .separator: TRSBaseColorDefinitions.accent.blend(with: TRSBaseColorDefinitions.white, ratio: 0.8),
        .shadow: TRSBaseColorDefinitions.shadow,
        .error: TRSBaseColorDefinitions.red.withOpacity(0.8),
        .warning: TRSBaseColorDefinitions.yellow.withOpacity(0.8),
        .secondaryBackground: TRSBaseColorDefinitions.ground.blend(with: TRSBaseColorDefinitions.white, ratio: 0.8),
        .highlightedBackground: TRSBaseColorDefinitions.accent.withOpacity(0.5),
        .uiElement: TRSBaseColorDefinitions.text.withOpacity(0.3),
        .clear: TRSBaseColorDefinitions.none,
        .secondaryText: TRSBaseColorDefinitions.secondary
    ])

    static let dark = Theme(name: "Dark", colorMapping: [
        .background: TRSBaseColorDefinitions.text,
        .text: TRSBaseColorDefinitions.ground,
        .headline: TRSBaseColorDefinitions.white,
        .accent: TRSBaseColorDefinitions.accent,
        .separator: TRSBaseColorDefinitions.text.withOpacity(0.1),
        .shadow: TRSBaseColorDefinitions.primary,
        .error: TRSBaseColorDefinitions.red.withOpacity(0.1),
        .warning: TRSBaseColorDefinitions.yellow.withOpacity(0.1),
        .secondaryBackground: TRSBaseColorDefinitions.text.withOpacity(0.8),
        .highlightedBackground: TRSBaseColorDefinitions.primary.withOpacity(0.5),
        .uiElement: TRSBaseColorDefinitions.ground.withOpacity(0.3),
        .clear: TRSBaseColorDefinitions.none,
        .secondaryText: TRSBaseColorDefinitions.secondary
    ])
}
