//
//  Shadow.swift
//  trs-system
//
//  Created by Fabian S. Klinke on 2024-07-30.
//
import SwiftUI

extension View {
    public func shadow(_ baseSize: TRSSizes, x: CGFloat = 0, y: CGFloat = 0, color: DynamicTRSColor = .shadow,
                       opacity: Double = 1) -> some View {
        shadow(baseSize: baseSize.value, color: color.color.opacity(opacity), x: x, y: y)
    }

    public func shadow(baseSize: CGFloat, color: Color, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        shadow(color: color, radius: baseSize / 5, x: x, y: y)
            .shadow(color: color, radius: baseSize / 1.5, x: x, y: y)
            .shadow(color: color, radius: baseSize * 2, x: x, y: y)
    }
}
