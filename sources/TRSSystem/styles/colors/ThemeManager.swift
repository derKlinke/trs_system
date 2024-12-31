import SwiftUI

// MARK: - ThemeManager
@MainActor
public final class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: Theme
    
    public init(theme: Theme = .light) {
        self.currentTheme = theme
    }
    
    /// Retrieves the current color for a given `ThemeElement`.
    public func color(for element: ThemeElement) -> TRSColor {
        currentTheme.color(for: element)
    }
    
    /// Switch to a specific theme
    public func switchTheme(to theme: Theme) {
        withAnimation {
            currentTheme = theme
        }
    }
    
    /// Toggle between light and dark theme
    public func toggleTheme() {
        withAnimation {
            currentTheme = (currentTheme.name == "Light") ? .dark : .light
        }
    }
    
    /// Update theme based on system appearance
    public func updateForSystemAppearance(_ appearance: ColorScheme) {
        switch appearance {
        case .light:
            if currentTheme.name != "Light" {
                switchTheme(to: .light)
            }
        case .dark:
            if currentTheme.name != "Dark" {
                switchTheme(to: .dark)
            }
        @unknown default:
            break
        }
    }
}
