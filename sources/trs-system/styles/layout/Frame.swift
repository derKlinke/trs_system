import SwiftUI

extension View {
    public func frame(minWidth: TRSSizes? = nil,
                      idealWidth: TRSSizes? = nil,
                      maxWidth: TRSSizes? = nil,
                      minHeight: TRSSizes? = nil,
                      idealHeight: TRSSizes? = nil,
                      maxHeight: TRSSizes? = nil,
                      alignment: Alignment = .center) -> some View {
        self.frame(minWidth: minWidth?.value,
                   idealWidth: idealWidth?.value,
                   maxWidth: maxWidth?.value,
                   minHeight: minHeight?.value,
                   idealHeight: idealHeight?.value,
                   maxHeight: maxHeight?.value,
                   alignment: alignment)
    }

    public func frame(width: TRSSizes? = nil,
                      height: TRSSizes? = nil,
                      alignment: Alignment = .center) -> some View {
        self.frame(width: width?.value,
                   height: height?.value,
                   alignment: alignment)
    }

    public func frame(square: TRSSizes) -> some View {
        self.frame(width: square.value, height: square.value)
    }
}
