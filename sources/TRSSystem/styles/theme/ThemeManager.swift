import SwiftUI

// MARK: - ThemeManager
@MainActor
public final class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: Theme
    @Environment(\.colorScheme) var colorScheme

    public init(theme: Theme) {
        self.currentTheme = theme
    }

    public init() {
        #if os(macOS)
            let systemColorScheme: ColorScheme
            if #available(macOS 10.14, *) {
                let appearance = NSApp.effectiveAppearance
                if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                    systemColorScheme = .dark
                } else {
                    systemColorScheme = .light
                }
            } else {
                systemColorScheme = .light
            }
        #elseif os(iOS)
            // For iOS, use UITraitCollection
            let systemColorScheme: ColorScheme = if UITraitCollection.current.userInterfaceStyle == .dark {
                .dark
            } else {
                .light
            }
        #endif

        self.currentTheme = systemColorScheme == .dark ? .dark : .light
    }

    /// Retrieves the current color for a given `ThemeElement`.
    public func color(for element: ThemeElement) -> TRSColor {
        currentTheme.color(for: element)
    }

    /// Switch to a specific theme
    public func switchTheme(to theme: Theme) {
        withAnimation {
            currentTheme = theme
            print("switched theme to \(theme.name)")
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
