import SwiftUI

// MARK: - VerticalSeparator
public struct Separator: View {
    @StateObject var colorManager = TRSColorManager.shared
    let shadow: Bool
    
    public enum Mode {
        case vertical
        case horizontal
    }
    
    private let size: TRSSizes
    private let width: CGFloat?
    private let height: CGFloat?

    public init(_ mode: Mode, shadow: Bool = false, size: TRSSizes = .tiny) {
        self.shadow = shadow
        self.size = size
        
        if mode == .vertical {
            width = size.value / 10
            height = nil
        } else {
            width = nil
            height = size.value / 10
        }
    }

    public var body: some View {
        // Actual separator
        let sepRectangle = Rectangle()
            .fill(DynamicTRSColor.separator.color)
            .frame(width: width, height: height)
        
        if shadow {
            sepRectangle
                .shadow(size)
        } else {
            sepRectangle
        }
    }
}
