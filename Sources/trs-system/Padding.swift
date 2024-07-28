import SwiftUI

public enum TRSPadding: Int {
    case tiny = -2
    case small = -1
    case medium = 0
    case large = 1
    case extraLarge = 2
    
    var value: CGFloat {
        BASE_SIZE * pow(GOLDEN_RATIO, CGFloat(rawValue))
    }
}


extension View {
    public func padding(trs: TRSPadding) -> some View {
        self.padding(trs.value)
    }
    
    public func padding(trs: TRSPadding, edges: Edge.Set) -> some View {
        self.padding(edges, trs.value)
    }
}
