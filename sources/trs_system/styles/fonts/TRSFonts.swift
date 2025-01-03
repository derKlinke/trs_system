import SwiftUI

// MARK: - TRSFontName
public enum TRSFontName: String, Sendable {
    case sansSerif = "Helvetica Neue"
    case serif = "Hoefler Text"
    case monospace = "Fira Code"
    case system = "System"

    var baseFontSize: CGFloat {
        switch self {
        case .sansSerif:
            BASE_SIZE
        case .serif:
            BASE_SIZE
        case .monospace:
            BASE_SIZE - 2
        case .system:
            BASE_SIZE
        }
    }
}

// MARK: - TRSFonts
public enum TRSFonts: Sendable {
    case headline
    case title
    case body
    case caption
    case mono
    case numDisplay
}

// MARK: - TRSFontAlignment
public enum TRSFontAlignment: Sendable {
    case left
    case center
    case right
}

let allFonts: [TRSFonts: TRSFontSpec] = [
    .caption: TRSFontSpec(name: .monospace, level: -1, bold: false, colorElement: .secondaryText),
    .body: TRSFontSpec(name: .system, level: 0, bold: false),
    .headline: TRSFontSpec(name: .system, level: 0.3, bold: true, colorElement: .headline),
    .title: TRSFontSpec(name: .system, level: 1, bold: true, colorElement: .headline),
    .mono: TRSFontSpec(name: .monospace, level: 0, bold: false),
    .numDisplay: TRSFontSpec(name: .monospace, level: 1, bold: true, colorElement: .headline),
]

// MARK: - TRSFontSpec
struct TRSFontSpec: Sendable {
    let name: TRSFontName
    let level: CGFloat
    let bold: Bool
    let colorElement: ThemeElement

    init(name: TRSFontName, level: CGFloat, bold: Bool, colorElement: ThemeElement = .text) {
        self.name = name
        self.level = level
        self.bold = bold
        self.colorElement = colorElement
    }
}

// MARK: - TRSFontSpecViewModifier
struct TRSFontSpecViewModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager

    let spec: TRSFontSpec
    let alignment: TRSFontAlignment

    let desiredLineHeight: CGFloat
    let pointFontSize: CGFloat
    let linespacing: CGFloat
    let topPadding: CGFloat
    let bottomPadding: CGFloat
    let font: Font

    init(spec: TRSFontSpec, padding: Bool, alignment: TRSFontAlignment) {
        self.spec = spec
        self.alignment = alignment

        // Initialize with temporary values first
        let tempFontSize = spec.name.baseFontSize * pow(GOLDEN_RATIO, spec.level)
        self.desiredLineHeight = tempFontSize * GOLDEN_RATIO

        // Create the font
        if spec.name == .system {
            self.font = Font.system(size: tempFontSize)
            self.pointFontSize = tempFontSize
        } else {
            self.font = Font.custom(spec.name.rawValue, size: tempFontSize)
            if let customFont = NSFont(name: spec.name.rawValue, size: tempFontSize) {
                self.pointFontSize = customFont.pointSize
            } else {
                self.pointFontSize = tempFontSize
            }
        }

        // Calculate derived values
        self.linespacing = self.desiredLineHeight - self.pointFontSize

        if padding {
            self.topPadding = (self.linespacing / 3) * 2
            self.bottomPadding = self.linespacing / 3
        } else {
            self.topPadding = 0.0
            self.bottomPadding = 0.0
        }
    }

    func body(content: Content) -> some View {
        _applyAlignment(content
            .font(self.font)
            .bold(spec.bold)
            .lineSpacing(linespacing)
            .foregroundColor(Color(themeManager.color(for: spec.colorElement).color)))
    }

    @ViewBuilder
    func _applyAlignment(_ content: some View) -> some View {
        switch alignment {
        case .left:
            content.frame(maxWidth: .infinity, alignment: .leading)
        case .center:
            content
        case .right:
            content.frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

extension View {
    public func font(trs: TRSFonts, padding: Bool = true,
                     alignment: TRSFontAlignment = .center) -> some View {
        if let _font = allFonts[trs] {
            return self.modifier(TRSFontSpecViewModifier(spec: _font, padding: padding, alignment: alignment))
        } else {
            fatalError("Font not found")
        }
    }

    func withFontSpec(_ spec: TRSFontSpec, padding: Bool = true,
                      alignment: TRSFontAlignment = .center) -> some View {
        self.modifier(TRSFontSpecViewModifier(spec: spec, padding: padding, alignment: alignment))
    }
}

#Preview {
    VStack(spacing: 0) {
        Text("Title")
            .font(trs: .title)

        Text("Headline")
            .font(trs: .headline)

        Text("Body")
            .font(trs: .body)

        Text("Caption")
            .font(trs: .caption)
    }
    .padding()
    .frame(width: 200)
    .frame(maxHeight: .infinity)
}
