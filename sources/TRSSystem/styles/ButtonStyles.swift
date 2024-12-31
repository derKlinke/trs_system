import SwiftUI

// MARK: - TRSButtonStyle
public struct TRSButtonStyle: ButtonStyle {
    @EnvironmentObject private var themeManager: ThemeManager

    var colorElement: ThemeElement

    public init(colorElement: ThemeElement = .secondaryBackground) {
        self.colorElement = colorElement
    }

    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        let buttonColor = Color(themeManager.color(for: colorElement).color)

        let newConf = configuration.label
            .padding(.horizontal, 8)
            .frame(minHeight: .large)
            .background(buttonColor)
            .font(trs: .mono)

        if buttonColor != Color.clear {
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
// FIXME: we need to find a concurrency safe way to do this
// @MainActor
// public struct TRSTextFieldStyle: TextFieldStyle {
//     @EnvironmentObject private var themeManager: ThemeManager

//     public init() {}

//     public func _body(configuration: TextField<Self._Label>) -> some View {
//         // Wrap the body content in a MainActor.run block
//         let backgroundColor = Color(themeManager.color(for: .secondaryBackground).color)
//         let textColor = Color(themeManager.color(for: .text).color)

//         return configuration
//             .textFieldStyle(PlainTextFieldStyle())
//             .padding(.horizontal, .small)
//             .frame(minHeight: .large)
//             .background(backgroundColor)
//             .foregroundColor(textColor)
//             .font(trs: .mono)
//             .borderClip(.tiny)
//     }
// }

// MARK: - TRSToggleStyle
public struct TRSToggleStyle: ToggleStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isPressed = false // Make sure to mark as private for encapsulation

    public init() {}

    private let toggleFontSpec = TRSFontSpec(name: .sansSerif, level: -1, bold: true)

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                let onColor = Color(themeManager.color(for: .headline).color)
                let offColor = Color(themeManager.color(for: .secondaryBackground).color)

                Rectangle()
                    .fill(configuration.isOn ? onColor : offColor)

                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(offColor)
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
