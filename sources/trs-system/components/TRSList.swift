import SwiftUI

// MARK: - TRSSelectionMode
public enum TRSSelectionMode<ID: Hashable> {
    case single(Binding<ID?>)
    case multiple(Binding<Set<ID>>)
}

// MARK: - TRSList
public struct TRSList<Data, ID, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable,
    ID: Hashable, Content: View {
    private var data: Data
    private var id: KeyPath<Data.Element, ID>
    private var content: (Data.Element) -> Content
    private var selectionMode: TRSSelectionMode<ID>
    @State private var lastSelectedID: ID?

    @StateObject private var colorManager = TRSColorManager.shared

    private init(data: Data, id: KeyPath<Data.Element, ID>, selectionMode: TRSSelectionMode<ID>,
                 @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.selectionMode = selectionMode
        self.content = content
    }

    public init(data: Data, id: KeyPath<Data.Element, ID>, singleSelection: Binding<ID?>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data: data, id: id, selectionMode: .single(singleSelection), content: content)
    }

    public init(data: Data, id: KeyPath<Data.Element, ID>, multipleSelection: Binding<Set<ID>>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data: data, id: id, selectionMode: .multiple(multipleSelection), content: content)
    }

    public var body: some View {
        ZStack {
            // Background tap area
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    clearSelection()
                }

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(data, id: id) { item in
                        content(item)
                            .padding(.tiny)
                            .background(isSelected(item) ? DynamicTRSColor.highlightedContentBackground
                                .color : Color.clear)
                            .roundedClip(.tiny)
                            .padding(.vertical, 1)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                handleSelection(of: item[keyPath: id])
                            }
                    }
                }
            }
            .onTapGesture {
                clearSelection()
            }
            .focusable()
            .focusEffectDisabled()
            .onCommand(#selector(NSStandardKeyBindingResponding.selectAll(_:))) {
                selectAllItems()
            }
            .onCommand(#selector(NSStandardKeyBindingResponding.cancelOperation(_:))) {
                clearSelection()
            }
            .scrollContentBackground(.hidden)
            .padding(.top, .medium)
        }
    }

    private func handleSelection(of itemID: ID) {
        switch selectionMode {
        case let .single(binding):
            if binding.wrappedValue == itemID {
                binding.wrappedValue = nil
            } else {
                binding.wrappedValue = itemID
            }
        case let .multiple(binding):
            if let lastID = lastSelectedID, NSEvent.modifierFlags.contains(.shift) {
                guard let startIndex = data.firstIndex(where: { $0[keyPath: id] == lastID }),
                      let endIndex = data.firstIndex(where: { $0[keyPath: id] == itemID }) else {
                    return
                }
                let range = min(startIndex, endIndex) ... max(startIndex, endIndex)
                let itemsInRange = data[range].map { $0[keyPath: id] }
                binding.wrappedValue.formUnion(itemsInRange)
            } else {
                if !NSEvent.modifierFlags.contains(.shift) {
                    binding.wrappedValue.removeAll()
                }
                binding.wrappedValue.insert(itemID)
            }
            lastSelectedID = itemID
        }
    }

    private func selectAllItems() {
        switch selectionMode {
        case let .multiple(binding):
            binding.wrappedValue = Set(data.map { $0[keyPath: id] })
        default:
            break
        }
    }

    private func clearSelection() {
        switch selectionMode {
        case let .single(binding):
            binding.wrappedValue = nil
        case let .multiple(binding):
            binding.wrappedValue.removeAll()
        }
    }

    private func isSelected(_ item: Data.Element) -> Bool {
        switch selectionMode {
        case let .single(binding):
            return binding.wrappedValue == item[keyPath: id]
        case let .multiple(binding):
            return binding.wrappedValue.contains(item[keyPath: id])
        }
    }
}
