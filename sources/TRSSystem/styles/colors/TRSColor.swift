import SwiftUI

public struct TRSColor: Equatable, Sendable {
    public let name: String
    public let ral: String
    public let hex: UInt
    public let opacity: CGFloat
    public let color: Color

    public init(name: String, ral: String = "n/a", hex: UInt, opacity: CGFloat = 1.0) {
        self.name = name
        self.ral = ral
        self.hex = hex
        self.opacity = opacity

        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.color = Color(.sRGB, red: red, green: green, blue: blue, opacity: Double(opacity))
    }

    /// Creates a new `TRSColor` with adjusted opacity.
    public func withOpacity(_ opacity: CGFloat) -> TRSColor {
        TRSColor(name: name, ral: ral, hex: hex, opacity: opacity)
    }

    /// Blends this color with another `TRSColor` based on the given ratio.
    public func blend(with color: TRSColor, ratio: Double = 0.5) -> TRSColor {
        let clampedRatio = max(0, min(1, ratio))
        let inverseRatio = 1 - clampedRatio

        let red = Double((self.hex >> 16) & 0xFF) * inverseRatio + Double((color.hex >> 16) & 0xFF) *
            clampedRatio
        let green = Double((self.hex >> 8) & 0xFF) * inverseRatio + Double((color.hex >> 8) & 0xFF) *
            clampedRatio
        let blue = Double(self.hex & 0xFF) * inverseRatio + Double(color.hex & 0xFF) * clampedRatio

        let blendedHex = (UInt(red) << 16) | (UInt(green) << 8) | UInt(blue)
        let blendedOpacity = self.opacity * inverseRatio + color.opacity * clampedRatio

        return TRSColor(name: "\(self.name) x \(color.name)", ral: "n/a", hex: blendedHex,
                        opacity: CGFloat(blendedOpacity))
    }

    /// Returns the HEX string representation of the color.
    public var hexString: String {
        String(format: "#%06X", hex)
    }
}
