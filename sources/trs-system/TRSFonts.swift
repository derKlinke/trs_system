//
//  File.swift
//
//
//  Created by Fabian S. Klinke on 2024-07-25.
//

import SwiftUI

// MARK: - TRSFontName
public enum TRSFontName: String {
    case sansSerif = "Helvetica Neue"
    case serif = "Hoefler Text"
    case monospace = "Fira Code"

    var baseFontSize: CGFloat {
        switch self {
        case .sansSerif:
            BASE_SIZE
        case .serif:
            BASE_SIZE
        case .monospace:
            BASE_SIZE - 2
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
}

// MARK: - TRSFontAlignment
public enum TRSFontAlignment {
    case left
    case center
    case right
}

let allFonts: [TRSFonts: TRSFontSpec] = [
    .caption: TRSFontSpec(name: .monospace, level: -1, bold: false, color: .secondaryText),
    .body: TRSFontSpec(name: .sansSerif, level: 0, bold: false),
    .headline: TRSFontSpec(name: .sansSerif, level: 0.3, bold: true, color: .headline),
    .title: TRSFontSpec(name: .sansSerif, level: 1, bold: true, color: .headline),
    .mono: TRSFontSpec(name: .monospace, level: 0, bold: false),
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

    init(spec: TRSFontSpec, padding: Bool, color: TRSColors?, alignment: TRSFontAlignment) {
        self.spec = spec
        self.alignment = alignment
        
        if let color {
            self.color = color.color
        } else {
            self.color = spec.color.color
        }

        guard let font = NSFont(name: spec.name.rawValue, size: fontSize(level: spec.level)) else {
            fatalError("Font not found")
        }

        self.desiredLineHeight = fontSize(level: spec.level) * GOLDEN_RATIO
        self.pointFontSize = font.pointSize
        self.linespacing = desiredLineHeight - pointFontSize

        if padding {
            topPadding = (linespacing / 3) * 2
            bottomPadding = linespacing / 3
        }

    }

    func body(content: Content) -> some View {
        _applyAlignment(content
            .font(.custom(spec.name.rawValue, size: fontSize(level: spec.level)))
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
