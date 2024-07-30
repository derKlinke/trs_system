import AppKit
import SwiftUI
@testable import trs_system
import XCTest

final class LongformFontSnapshotTests: XCTestCase {
    func testLongformFontShowcase() throws {
        let preview = VStack(spacing: 0) {
            Text("Font Showcase")
                .font(trs: .title)

            Text("Introduction to Typography")
                .font(trs: .headline)
                .padding(.top, .medium)

            Text(loremIpsum)
                .font(trs: .body, padding: false,alignment: .left)

            Text("The Importance of Fonts")
                .font(trs: .headline)

            Text(loremIpsum)
                .font(trs: .body, padding: false,alignment: .left)

            Text("Mono Font Showcase")
                .font(trs: .headline)
                .padding(.top, .medium)

            Text("Here's an example of our mono font:")
                .font(trs: .body, padding: false,alignment: .left)

            Text("func helloWorld() {\n    print(\"Hello, World!\")\n}")
                .font(trs: .mono, padding: false,alignment: .left)
        }

        let hostingView = NSHostingView(rootView: preview)

        let snapshotImage = takeAndSaveSnapshot(of: hostingView, named: "font-showcase",
                                                size: CGSize(width: 600, height: 1_200))

        let attachment = XCTAttachment(image: snapshotImage)
        attachment.name = "LongformFontShowcase"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private let loremIpsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
    """
}
