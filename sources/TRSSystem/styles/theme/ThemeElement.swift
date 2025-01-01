// MARK: - ThemeElement

public enum ThemeElement: String, CaseIterable, Identifiable, Sendable {
    case background
    case sidebarBackground
    case contentBackground
    case secondaryContentBackground
    case highlightedContentBackground
    case text
    case headline
    case secondaryText
    case accent
    case separator
    case success
    case shadow
    case error
    case warning
    case uiElement
    case clear

    public var id: String { rawValue }
}
