import Foundation

public enum TRSSizes: Sendable {
    case tiny
    case small
    case medium
    case large
    case huge
    case gigantic
    case custom(level: Double)

    public var value: CGFloat {
        BASE_SIZE * pow(GOLDEN_RATIO, CGFloat(rawValue))
    }

    public var rawValue: Double {
        switch self {
        case .tiny: -2
        case .small: -1
        case .medium: 0
        case .large: 1
        case .huge: 3
        case .gigantic: 4
        case let .custom(level): level
        }
    }
}
