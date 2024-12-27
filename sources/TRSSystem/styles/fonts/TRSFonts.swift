import SwiftUI

// MARK: - TRSFontName
public enum TRSFontName: String {
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
public enum TRSFonts {
    case headline
    case title
    case body
    case caption
    case mono
    case numDisplay
}

// MARK: - TRSFontAlignment
public enum TRSFontAlignment {
    case left
    case center
    case right
}

let allFonts: [TRSFonts: TRSFontSpec] = [
    .caption: TRSFontSpec(name: .monospace, level: -1, bold: false, color: .secondaryText),
    .body: TRSFontSpec(name: .system, level: 0, bold: false),
    .headline: TRSFontSpec(name: .system, level: 0.3, bold: true, color: .headline),
    .title: TRSFontSpec(name: .system, level: 1, bold: true, color: .headline),
    .mono: TRSFontSpec(name: .monospace, level: 0, bold: false),
    .numDisplay: TRSFontSpec(name: .monospace, level: 1, bold: true, color: .headline),
]

// MARK: - TRSFontSpec
struct TRSFontSpec {
    let name: TRSFontName
    let level: CGFloat
    let bold: Bool
    let color: DynamicTRSColor

    init(name: TRSFontName, level: CGFloat, bold: Bool, color: DynamicTRSColor = .text) {
        self.name = name
        self.level = level
        self.bold = bold
        self.color = color
    }
}

// MARK: - TRSFontSpecViewModifier
struct TRSFontSpecViewModifier: ViewModifier {
    let spec: TRSFontSpec
    let color: Color
    let alignment: TRSFontAlignment

    var desiredLineHeight: CGFloat = 0.0
    var pointFontSize: CGFloat = 0.0
    var linespacing: CGFloat = 0.0
    var topPadding = 0.0
    var bottomPadding = 0.0

    var font: Font?

    init(spec: TRSFontSpec, padding: Bool, color: TRSColors?, alignment: TRSFontAlignment) {
        self.spec = spec
        self.alignment = alignment

        // Initialize color property
        if let color {
            self.color = color.color
        } else {
            self.color = spec.color.color
        }

        // Temporary variables to hold intermediate values
        let fontSizeLevel = fontSize(level: spec.level)
        let font: NSFont

        // Initialize font property
        if spec.name == .system {
            self.font = Font.system(size: fontSizeLevel)
            font = NSFont.systemFont(ofSize: fontSizeLevel)
        } else {
            self.font = Font.custom(spec.name.rawValue, size: fontSizeLevel)
            guard let customFont = NSFont(name: spec.name.rawValue, size: fontSizeLevel) else {
                fatalError("Font not found")
            }
            font = customFont
        }

        // Calculate derived properties
        self.desiredLineHeight = fontSizeLevel * GOLDEN_RATIO
        self.pointFontSize = font.pointSize
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
            .font(self.font!)
            .bold(spec.bold)
            .lineSpacing(linespacing)
            .foregroundColor(color))
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

    func fontSize(level: CGFloat) -> CGFloat {
        spec.name.baseFontSize * pow(GOLDEN_RATIO, level)
    }
}

extension View {
    public func font(trs: TRSFonts, padding: Bool = true, color: TRSColors? = nil,
                     alignment: TRSFontAlignment = .center) -> some View {
        if let _font = allFonts[trs] {
            return self.modifier(TRSFontSpecViewModifier(spec: _font, padding: padding, color: color,
                                                         alignment: alignment))
        } else {
            fatalError("Font not found")
        }
    }

    func withFontSpec(_ spec: TRSFontSpec, padding: Bool = true, color: TRSColors? = nil,
                      alignment: TRSFontAlignment = .center) -> some View {
        self.modifier(TRSFontSpecViewModifier(spec: spec, padding: padding, color: color,
                                              alignment: alignment))
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
