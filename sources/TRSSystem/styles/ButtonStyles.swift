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

// MARK: - TRSToggleStyle
public struct TRSToggleStyle: ToggleStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isPressed = false

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
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    if isPressed {
                        isPressed = false
                        configuration.isOn.toggle()
                    }
                })

            configuration.label
                .font(trs: .body)
        }
    }
}
