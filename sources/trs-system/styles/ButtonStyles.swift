//
//  ButtonStyles.swift
//  Oscar
//
//  Created by Fabian S. Klinke on 2024-06-30.
//

import SwiftUI
import trs_system

// MARK: - TRSButtonStyle
public struct TRSButtonStyle: ButtonStyle {
    var color: Color

    @StateObject var colorManager = TRSColorManager.shared

    public init(color: DynamicTRSColor = .contentBackground) {
        self.color = color.color
    }

    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        let newConf = configuration.label
            .padding(.horizontal, 8)
            .frame(minHeight: .large)
            .background(color)
            .font(trs: .mono)

        if color != Color.clear {
            newConf
                .borderClip(.tiny)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.spring(), value: configuration.isPressed)
        } else {
            newConf
                .roundedClip(.tiny)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.spring(), value: configuration.isPressed)
        }
    }
}

// MARK: - TRSTextFieldStyle
public struct TRSTextFieldStyle: TextFieldStyle {
    @StateObject var colorManager = TRSColorManager.shared

    public init() {}

    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, .small)
            .frame(minHeight: .large)
            .background(DynamicTRSColor.contentBackground.color)
            .foregroundColor(DynamicTRSColor.headline.color)
            .font(trs: .mono)
            .borderClip(.tiny)
    }
}
