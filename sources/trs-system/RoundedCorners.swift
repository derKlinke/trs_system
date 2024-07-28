import Foundation
import SwiftUI

public struct RoundedTRSRectangle: Shape {
    let level: CGFloat
    
    init(level: CGFloat) {
        self.level = level
    }
    
    public func path(in rect: CGRect) -> Path {
        let cornerRadius = BASE_SIZE * pow(GOLDEN_RATIO, level)
        
        return Path(roundedRect: rect, cornerRadius: cornerRadius)
    }
}

public struct RoundedClip: ViewModifier {
    let level: CGFloat
    
    init(level: CGFloat) {
        self.level = level
    }
    
    public func body(content: Content) -> some View {
        content.clipShape(RoundedTRSRectangle(level: level))
    }
}

extension View {
    public func roundedClip(level: CGFloat = 0) -> some View {
        self.modifier(RoundedClip(level: level))
    }
}
