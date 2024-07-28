//
//  File.swift
//  
//
//  Created by Fabian S. Klinke on 2024-07-28.
//

import SwiftUI

public struct VerticalSeperator: View {
    @StateObject var colorManager = TRSColorManager.shared
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(DynamicTRSColor.shadow.color)
            .frame(width: 1)
    }
}

public struct HorizontalSeperator: View {
    @StateObject var colorManager = TRSColorManager.shared
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(DynamicTRSColor.shadow.color)
            .frame(height: 1)
    }
}
