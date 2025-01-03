// MARK: - TRSBaseColorDefinitions

enum TRSBaseColorDefinitions {
    static let white = TRSColor(name: "WHITE", hex: 0xFFFFFF)
    static let ground = TRSColor(name: "GROUND", hex: 0xE9E9E6)
    static let accent = TRSColor(name: "ACCENT", hex: 0xD1D0C7)
    static let secondary = TRSColor(name: "SECONDARY", hex: 0xADABA0)
    static let text = TRSColor(name: "TEXT", hex: 0x1B1818)
    static let primary = TRSColor(name: "PRIMARY", hex: 0x0F0F10)
    static let shadow = TRSBaseColorDefinitions.text.withOpacity(0.1)
    static let red = TRSColor(name: "RED", hex: 0xFF0000)
    static let yellow = TRSColor(name: "YELLOW", hex: 0xFFFF00)
    static let green = TRSColor(name: "GREEN", hex: 0x708C64)
    static let none = TRSColor(name: "NONE", hex: 0x000000, opacity: 0.0)
}
