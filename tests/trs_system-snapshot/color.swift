import AppKit
import SwiftUI
@testable import trs_system
import XCTest

// MARK: - ColorSwatchSnapshotTests
final class ColorSwatchSnapshotTests: XCTestCase {
    func testAllColorSwatchesPreview() throws {
        let systemcolors = [
            TRSColors.ground,
            TRSColors.accent,
            TRSColors.secondary,
            TRSColors.text,
            TRSColors.primary,
        ]

        let colors = [
            TRSColors.red,
            TRSColors.green,
            TRSColors.blue,
            TRSColors.yellow,
        ]

        let preview = VStack {
            Text("TRS SYSTEM COLORS")
                .font(trs: .title)

            VStack {
                HStack {
                    ForEach(systemcolors) { color in
                        ColorSwatch(color)
                            .padding(.small)
                    }
                }

                HStack {
                    ForEach(colors) { color in
                        ColorSwatch(color)
                            .padding(.small)
                    }
                }
            }
        }
        .padding()

        let hostingView = NSHostingView(rootView: preview)
        hostingView.frame = CGRect(x: 0, y: 0, width: 1_200, height: 600)

        let snapshotImage = takeAndSaveSnapshot(of: hostingView, named: "system-colors")

        let attachment = XCTAttachment(image: snapshotImage)
        attachment.name = "AllColorSwatches"
        attachment.lifetime = .keepAlways
        add(attachment)

        // If you have a reference image, you can compare like this:
        // XCTAssertEqual(snapshotImage.tiffRepresentation, referenceImage.tiffRepresentation)
    }
}
