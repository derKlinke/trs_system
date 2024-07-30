import SwiftUI

extension View {
    public func padding(_ trs: TRSSizes) -> some View {
        self.padding(trs.value)
    }

    public func padding(_ edges: Edge.Set, _ trs: TRSSizes) -> some View {
        self.padding(edges, trs.value)
    }
}
