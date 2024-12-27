//
//  ButtonStyles.swift
//  Oscar
//
//  Created by Fabian S. Klinke on 2024-06-30.
//

import SwiftUI

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

// MARK: - TRSToggleStyle
public struct TRSToggleStyle: ToggleStyle {
    @StateObject var colorManager = TRSColorManager.shared
    @State private var isPressed = false // Make sure to mark as private for encapsulation

    public init() {}

    private let toggleFontSpec = TRSFontSpec(name: .sansSerif, level: -1, bold: true)

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(configuration.isOn ? DynamicTRSColor.text.color : DynamicTRSColor.contentBackground
                        .color)

                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(DynamicTRSColor.contentBackground.color)
                        .withFontSpec(toggleFontSpec)
                }
            }
            .frame(square: .medium)
            .borderClip(.tiny)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(duration: 0.1), value: isPressed)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    // Triggered when the gesture starts
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    // Triggered when the gesture ends
                    if isPressed {
                        isPressed = false
                        configuration.isOn.toggle() // Toggle the state on release
                    }
                })

            configuration.label
                .font(trs: .body)
        }
    }
}
