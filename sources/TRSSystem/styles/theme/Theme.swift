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

extension Theme {
    public static let light = Theme(name: "Light", colorMapping: [
        // BACKGROUNDS
        .background: TRSBaseColorDefinitions.white,
        .contentBackground: TRSBaseColorDefinitions.ground.blend(with: TRSBaseColorDefinitions.white,
                                                                 ratio: 0.8),
        .secondaryContentBackground: TRSBaseColorDefinitions.ground.blend(with: TRSBaseColorDefinitions.white,
                                                                          ratio: 0.7),
        .highlightedContentBackground: TRSBaseColorDefinitions.accent.withOpacity(0.5),
        .sidebarBackground: TRSBaseColorDefinitions.ground.blend(with: TRSBaseColorDefinitions.white,
                                                                 ratio: 0.1).withOpacity(0.3),

        // TEXT
        .headline: TRSBaseColorDefinitions.primary,
        .text: TRSBaseColorDefinitions.text,
        .secondaryText: TRSBaseColorDefinitions.secondary,
        .accent: TRSBaseColorDefinitions.accent,

        // OTHER
        .shadow: TRSBaseColorDefinitions.text.blend(with: TRSBaseColorDefinitions.ground).withOpacity(0.1),
        .error: TRSBaseColorDefinitions.red.withOpacity(0.8),
        .warning: TRSBaseColorDefinitions.yellow.withOpacity(0.8),
        .success: TRSBaseColorDefinitions.green.withOpacity(0.8),
        .uiElement: TRSBaseColorDefinitions.text.withOpacity(0.3),
        .separator: TRSBaseColorDefinitions.accent.withOpacity(0.5),
        .clear: TRSBaseColorDefinitions.none,
    ])

    public static let dark = Theme(name: "Dark", colorMapping: [
        // BACKGROUNDS
        .background: TRSBaseColorDefinitions.text,
        .contentBackground: TRSBaseColorDefinitions.text.blend(with: TRSBaseColorDefinitions.ground,
                                                               ratio: 0.06),
        .secondaryContentBackground: TRSBaseColorDefinitions.text.blend(with: TRSBaseColorDefinitions.ground,
                                                                        ratio: 0.04),
        .highlightedContentBackground: TRSBaseColorDefinitions.accent.withOpacity(0.3),
        .sidebarBackground: TRSBaseColorDefinitions.text.blend(with: TRSBaseColorDefinitions.ground,
                                                               ratio: 0.08).withOpacity(0.3),

        // TEXT
        .headline: TRSBaseColorDefinitions.white,
        .text: TRSBaseColorDefinitions.ground,
        .secondaryText: TRSBaseColorDefinitions.secondary,
        .accent: TRSBaseColorDefinitions.accent,

        // OTHER
        .shadow: TRSBaseColorDefinitions.primary.withOpacity(0.2),
        .error: TRSBaseColorDefinitions.red.withOpacity(0.8),
        .warning: TRSBaseColorDefinitions.yellow.withOpacity(0.8),
        .success: TRSBaseColorDefinitions.green.withOpacity(0.8),
        .uiElement: TRSBaseColorDefinitions.ground.withOpacity(0.3),
        .separator: TRSBaseColorDefinitions.primary.withOpacity(0.5),
        .clear: TRSBaseColorDefinitions.none,
    ])
}
