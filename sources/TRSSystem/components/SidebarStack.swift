import SwiftUI

// MARK: - SidebarStack
public struct SidebarStack<SidebarContent, Content>: View where SidebarContent: View, Content: View {
    @ViewBuilder var sidebarContent: () -> SidebarContent
    @ViewBuilder var content: () -> Content

    @State private var isDraggingSidebar = false
    @State private var sidebarWidth: CGFloat = 200

    @State private var colorManager = TRSColorManager.shared

    private let kSidebarResizeWidth: CGFloat = 10
    private let minSidebarWidth: CGFloat = 100
    private let maxSidebarWidth: CGFloat = 300

    public init(@ViewBuilder sidebarContent: @escaping () -> SidebarContent,
                @ViewBuilder content: @escaping () -> Content) {
        self.sidebarContent = sidebarContent
        self.content = content
    }

    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    sidebarContent()
                }
                .padding(.horizontal, .medium)
                .padding(.top, .huge)
                .padding(.bottom, .medium)
                .frame(width: sidebarWidth)
                .frame(maxHeight: .infinity)
//                .background(DynamicTRSColor.secondaryContentBackground.color)
                .background(.regularMaterial)

                Separator(.vertical, shadow: true)

                VStack(spacing: 0) {
                    content()
                }
            }

            ToastOverlay()
            // Resizer overlay
            GeometryReader { geometry in
                HStack {
                    Spacer()
                        .frame(width: sidebarWidth - kSidebarResizeWidth)

                    ResizerView(isDragging: $isDraggingSidebar)
                        .frame(width: kSidebarResizeWidth)
                        .gesture(DragGesture()
                            .onChanged { value in
                                DispatchQueue.main.async {
                                    let newWidth = sidebarWidth + value.translation.width
                                    sidebarWidth = max(minSidebarWidth, min(newWidth, maxSidebarWidth))
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    isDraggingSidebar = false
                                }
                            })

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

// MARK: - ResizerView
struct ResizerView: View {
    @Binding var isDragging: Bool
    @State private var isHovering = false

    @State private var colorManager = TRSColorManager.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)

            if isDragging || isHovering {
                Rectangle()
                    .fill(DynamicTRSColor.uiElement.color)
                    .frame(width: 4)
                    .frame(height: 50)
                    .roundedClip()
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
            }
        }
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .cursor(.resizeLeftRight, keepActive: isDragging)
    }
}

extension View {
    public func cursor(_ cursor: NSCursor, keepActive: Bool = false) -> some View {
        if #available(macOS 13.0, *) {
            return self.onContinuousHover { phase in
                switch phase {
                case .active:
                    guard NSCursor.current != cursor else {
                        return
                    }
                    cursor.push()
                case .ended:
                    if !keepActive {
                        NSCursor.pop()
                    }
                }
            }
        } else {
            return self.onHover { inside in
                if inside {
                    cursor.push()
                } else {
                    if !keepActive {
                        NSCursor.pop()
                    }
                }
            }
        }
    }
}
