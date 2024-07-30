import SwiftUI
import XCTest

extension XCTestCase {
    func takeAndSaveSnapshot(of view: NSView, named name: String, size: CGSize? = nil) -> NSImage {
        // If a size is provided, resize the view
        if let size {
            view.frame.size = size
        }

        view.layoutSubtreeIfNeeded()

        // Use a higher scale factor for better resolution
        let scaleFactor: CGFloat = 2.0 // You can adjust this value; 2.0 is equivalent to @2x resolution
        let screenSize = view.bounds.size

        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            fatalError("Failed to create bitmap representation")
        }

        bitmapRep.pixelsWide = Int(screenSize.width * scaleFactor)
        bitmapRep.pixelsHigh = Int(screenSize.height * scaleFactor)
        bitmapRep.size = screenSize

        view.cacheDisplay(in: view.bounds, to: bitmapRep)

        let image = NSImage(size: screenSize)
        image.addRepresentation(bitmapRep)

        // Save the image
        if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
            let fileManager = FileManager.default

            // Get the current file's directory
            let currentFilePath = URL(fileURLWithPath: #file)
            let testsFolderPath = currentFilePath.deletingLastPathComponent().path

            // Create a "snapshots" directory within the Tests folder
            let snapshotsDirectory = (testsFolderPath as NSString).appendingPathComponent("snapshots")

            do {
                try fileManager.createDirectory(atPath: snapshotsDirectory, withIntermediateDirectories: true,
                                                attributes: nil)
                let filePath = (snapshotsDirectory as NSString).appendingPathComponent("\(name).png")
                try pngData.write(to: URL(fileURLWithPath: filePath))
                print("Snapshot saved at: \(filePath)")
            } catch {
                print("Failed to save snapshot: \(error)")
            }
        }

        return image
    }
}
