// MARK: - ThemeElement

public enum ThemeElement: String, CaseIterable, Identifiable, Sendable {
    case background
    case text
    case headline
    case secondaryText
    case accent
    case separator
    case shadow
    case error
    case warning
    case secondaryBackground
    case highlightedBackground
    case uiElement
    case clear

    public var id: String { rawValue }
}
