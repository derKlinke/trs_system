//
//  TRSManager.swift
//
//
//  Created by Fabian S. Klinke on 2024-07-25.
//

import CoreText
import SwiftUI
import OSLog

public class TRSManager {
    public static let shared = TRSManager()
    
    private let logger = Logger(subsystem: "com.klinke-studio.trs-system", category: "TRSManager")
    
    public func installFonts() {
        if isFontInstalled(fontName: "Fira Code") {
            logger.info("Font already installed")
            return
        }

        // list all available fonts
        let url =
            URL(string: "https://klinke-studio-public.s3.eu-west-1.amazonaws.com/fonts/FiraCode-VF.ttf")!

        downloadAndRegisterFont(from: url, fontName: "Fira Code") { sucess in
            if sucess {
                self.logger.info("Font installed")
            } else {
                self.logger.error("Failed to install font")
            }
        }
    }

    private func isFontInstalled(fontName: String) -> Bool {
        let fontNames = CTFontManagerCopyAvailableFontFamilyNames() as! [String]
        return fontNames.contains(fontName)
    }

    private func downloadAndRegisterFont(from url: URL, fontName: String, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL, error == nil else {
                self.logger.error("Failed to download font: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            do {
                let fontData = try Data(contentsOf: localURL)
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fontName).ttf")
                try fontData.write(to: tempURL)

                var error: Unmanaged<CFError>?
                if CTFontManagerRegisterFontsForURL(tempURL as CFURL, .process, &error) {
                    completion(true)
                } else {
                    if let error = error?.takeUnretainedValue() {
                        self.logger.error("Failed to register font: \(error.localizedDescription)")
                    }
                    completion(false)
                }
            } catch {
                self.logger.error("Failed to write font to disk: \(error.localizedDescription)")
                completion(false)
            }
        }

        task.resume()
    }
}
