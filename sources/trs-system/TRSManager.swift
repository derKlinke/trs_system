import CoreText
import OSLog
import SwiftUI

public class TRSManager {
    public static let shared = TRSManager()

    let fonts: [(name: String, bundlePath: URL)] = [
        (name: "Fira Code", bundlePath: Bundle.module.url(forResource: "FiraCode-VF", withExtension: "ttf")!),
    ]

    private let logger = Logger(subsystem: "studio.klinke.trs-system", category: "TRSManager")

    public func installFonts() {
        // list all available fonts
        for font in fonts {
            if isFontInstalled(fontName: font.name) {
                logger.info("Font already installed")
                return
            }

            // register font
            let fontURL = font.bundlePath
            var error: Unmanaged<CFError>?
            guard let fontData = CGDataProvider(url: fontURL as CFURL) else {
                logger.error("Failed to load font data")
                return
            }
            guard let fontRef = CGFont(fontData) else {
                logger.error("Failed to create font reference")
                return
            }
            if !CTFontManagerRegisterGraphicsFont(fontRef, &error) {
                logger.error("Failed to register font: \(error.debugDescription)")
            } else {
                logger.info("Font installed")
            }
        }
    }

    private func isFontInstalled(fontName: String) -> Bool {
        let fontNames = CTFontManagerCopyAvailableFontFamilyNames() as! [String]
        return fontNames.contains(fontName)
    }
}
