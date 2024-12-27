import Combine
import OSLog
import SwiftUI

// MARK: - TRSColorManager
// TODO: refactor theme colors into this class and have enum for color schemes. we then also need to have enum for
//  color name definitions for easy access in font constructors
public class TRSColorManager: ObservableObject {
    public static let shared = TRSColorManager()

    @Published public var colorScheme: ColorScheme = .light

    private let logger = Logger(subsystem: "studio.klinke.trs-system", category: "TRSColorManager")

    init() {
        DistributedNotificationCenter.default.addObserver(self,
                                                          selector: #selector(systemAppearanceChanged),
                                                          name: NSNotification
                                                              .Name("AppleInterfaceThemeChangedNotification"),
                                                          object: nil)

        colorScheme = self.getCurrentColorScheme()
    }

    @objc
    private func systemAppearanceChanged(notification: Notification) {
        colorScheme = self.getCurrentColorScheme()
    }

    public func getCurrentColorScheme() -> ColorScheme {
        if let app = NSApp {
            let appearance = app.effectiveAppearance
            if appearance.name == .darkAqua || appearance.name == .vibrantDark {
                logger.debug("Dark mode enabled")
                return .dark
            } else {
                logger.debug("Light mode enabled")
                return .light
            }
        } else {
            return .light
        }
    }
}

// MARK: - TRSColor
public struct TRSColor: Equatable {
    public let name: String
    public let ral: String
    public let hex: UInt
    public let opacity: CGFloat

    // computed properties
    let rgba: (red: Double, green: Double, blue: Double, alpha: Double)
    public let color: Color

    init(name: String, ral: String, hex: UInt, opacity: CGFloat = 1.0) {
        self.name = name
        self.ral = ral
        self.hex = hex
        self.opacity = opacity

        // convert hex to rgba
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double((hex >> 0) & 0xFF) / 255

        self.rgba = (red, green, blue, opacity)
        self.color = Color(Color.RGBColorSpace.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }

    public var hexString: String {
        String(format: "#%06X", hex)
    }

    public static func == (lhs: TRSColor, rhs: TRSColor) -> Bool {
        lhs.name == rhs.name &&
            lhs.ral == rhs.ral &&
            lhs.hex == rhs.hex &&
            lhs.opacity == rhs.opacity
    }

    public func opacity(_ opacity: CGFloat = BASE_OPACITY) -> Self {
        TRSColor(name: self.name, ral: self.ral, hex: self.hex, opacity: opacity)
    }

    public func blend(with color: TRSColor, ratio: Double = 0.5) -> Self {
        // convert underlying colors to NSColor and use built in blend function
        let nsColor = NSColor(red: CGFloat(rgba.red), green: CGFloat(rgba.green), blue: CGFloat(rgba.blue),
                              alpha: CGFloat(rgba.alpha))
        let nsColor2 = NSColor(red: CGFloat(color.rgba.red), green: CGFloat(color.rgba.green),
                               blue: CGFloat(color.rgba.blue), alpha: CGFloat(color.rgba.alpha))
        let blendedColor = nsColor.blended(withFraction: CGFloat(ratio), of: nsColor2)

        // convert back to rgba
        let red = Double(blendedColor!.redComponent)
        let green = Double(blendedColor!.greenComponent)
        let blue = Double(blendedColor!.blueComponent)
        let alpha = Double(blendedColor!.alphaComponent)

        // convert to hex
        let hex = UInt(red * 255) << 16 + UInt(green * 255) << 8 + UInt(blue * 255)

        return TRSColor(name: "\(self.name) x \(color.name)", ral: "n/a", hex: hex, opacity: CGFloat(alpha))
    }

    public func blend(with color: TRSColors, ratio: Double = 0.5) -> Self {
        self.blend(with: color.trsColor, ratio: ratio)
    }
}

// MARK: - TRSBaseColorDefinitions
enum TRSBaseColorDefinitions {
    public static let white = TRSColor(name: "WHITE", ral: "n/a", hex: 0xFFFFFF)
    public static let ground = TRSColor(name: "GROUND", ral: "RAL 9003", hex: 0xE9E9E6)
    public static let accent = TRSColor(name: "ACCENT", ral: "RAL 9002", hex: 0xD1D0C7)
    public static let secondary = TRSColor(name: "SECONDARY", ral: "RAL 7044", hex: 0xADABA0)
    public static let text = TRSColor(name: "TEXT", ral: "RAL 8022", hex: 0x1B1818)
    public static let primary = TRSColor(name: "PRIMARY", ral: "RAL 9005", hex: 0x0F0F10)

    public static let red = TRSColor(name: "RED", ral: "RAL 3018", hex: 0xD33847)
    public static let green = TRSColor(name: "GREEN", ral: "RAL 6011", hex: 0x708C64)
    public static let blue = TRSColor(name: "BLUE", ral: "RAL 5012", hex: 0x0C6BA7)
    public static let yellow = TRSColor(name: "YELLOW", ral: "RAL 1021", hex: 0xF3C100)

    public static let none = TRSColor(name: "NONE", ral: "n/a", hex: 0x000000, opacity: 0.0)

    public static let shadow = text.opacity(0.1)
}

// MARK: - TRSColors
public enum TRSColors: CaseIterable, Identifiable {
    case white
    case ground
    case accent
    case secondary
    case text
    case primary
    case red
    case green
    case blue
    case yellow
    case shadow

    public var trsColor: TRSColor {
        switch self {
        case .white: TRSBaseColorDefinitions.white
        case .ground: TRSBaseColorDefinitions.ground
        case .accent: TRSBaseColorDefinitions.accent
        case .secondary: TRSBaseColorDefinitions.secondary
        case .text: TRSBaseColorDefinitions.text
        case .primary: TRSBaseColorDefinitions.primary
        case .red: TRSBaseColorDefinitions.red
        case .green: TRSBaseColorDefinitions.green
        case .blue: TRSBaseColorDefinitions.blue
        case .yellow: TRSBaseColorDefinitions.yellow
        case .shadow: TRSBaseColorDefinitions.shadow
        }
    }

    public var color: Color {
        self.trsColor.color
    }

    public var id: String {
        self.trsColor.name
    }
}

extension Color {
    public init(trs: TRSColors) {
        self = trs.trsColor.color
    }
}

// MARK: - DynamicTRSColor
public enum DynamicTRSColor: String, CaseIterable, Identifiable, CustomStringConvertible {
    case text
    case highlightedText
    case secondaryText
    case headline

    case warning
    case error

    case contentBackground
    case secondaryContentBackground
    case highlightedContentBackground
    case separator
    case uiElement
    case shadow

    case clear

    private var _darkModeColor: TRSColor {
        switch self {
        case .text: TRSBaseColorDefinitions.ground
        case .highlightedText: TRSBaseColorDefinitions.white
        case .secondaryText: TRSBaseColorDefinitions.secondary
        case .headline: TRSBaseColorDefinitions.white
        case .warning: TRSBaseColorDefinitions.yellow.opacity(0.1)
        case .error: TRSBaseColorDefinitions.red.opacity(0.1)
        case .contentBackground: TRSBaseColorDefinitions.text
        case .secondaryContentBackground: TRSBaseColorDefinitions.text.opacity(0.8)
        case .highlightedContentBackground: TRSBaseColorDefinitions.primary.opacity(0.5)
        case .separator: TRSBaseColorDefinitions.text.opacity(0.1)
        case .uiElement: TRSBaseColorDefinitions.ground.opacity(0.3)
        case .shadow: TRSBaseColorDefinitions.primary
        case .clear: TRSBaseColorDefinitions.none
        }
    }

    private var _lightModeColor: TRSColor {
        switch self {
        case .text: TRSBaseColorDefinitions.text
        case .highlightedText: TRSBaseColorDefinitions.primary
        case .secondaryText: TRSBaseColorDefinitions.secondary
        case .headline: TRSBaseColorDefinitions.primary
        case .warning: TRSBaseColorDefinitions.yellow.opacity()
        case .error: TRSBaseColorDefinitions.red.opacity()
        case .contentBackground: TRSBaseColorDefinitions.white
        case .secondaryContentBackground: TRSBaseColorDefinitions.ground.blend(with: .white, ratio: 0.8)
        case .highlightedContentBackground: TRSBaseColorDefinitions.accent.opacity(0.5)
        case .separator: TRSBaseColorDefinitions.accent.blend(with: .white)
        case .uiElement: TRSBaseColorDefinitions.text.opacity(0.3)
        case .shadow: TRSBaseColorDefinitions.text.opacity(0.2)
        case .clear: TRSBaseColorDefinitions.none
        }
    }

    public var trsColor: TRSColor {
        switch TRSColorManager.shared.colorScheme {
        case .dark: return _darkModeColor
        case .light: return _lightModeColor
        @unknown default: return _lightModeColor
        }
    }

    public var color: Color {
        trsColor.color
    }

    private var _scheme: String {
        switch TRSColorManager.shared.colorScheme {
        case .dark: return "dark"
        case .light: return "light"
        @unknown default: return "unknown"
        }
    }

    public var id: String {
        self.rawValue + _scheme
    }

    public var description: String {
        "\(self.rawValue) (\(_scheme))"
    }
}

// MARK: - ColorSwatch
public struct ColorSwatch: View {
    let color: TRSColor

    init(_ trsColor: TRSColors) {
        self.color = trsColor.trsColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(color.color)
                .frame(height: 120)

            VStack(spacing: 0) {
                Text(color.name)
                    .font(trs: .headline)
                Text(color.ral)
                    .font(trs: .caption)
                Text(color.hexString)
                    .font(trs: .caption)
            }
            .padding(.small)
            .frame(maxWidth: .infinity)
            .background { Color(trs: .white) }
        }
        .frame(width: 120)
        .roundedClip()
        .shadow(color: Color(trs: .shadow), radius: 5, x: 1, y: 1)
    }
}

#Preview {
    VStack {
        Text("TRS SYSTEM COLORS")
            .font(trs: .title)

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(TRSColors.allCases) { color in
                ColorSwatch(color)
                    .padding(.medium)
            }
        }
        .frame(maxWidth: 400)
    }
    .padding()
}
