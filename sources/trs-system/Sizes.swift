import Foundation

public enum TRSSizes {
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
        case .tiny: return -2
        case .small: return -1
        case .medium: return 0
        case .large: return 1
        case .huge: return 3
        case .gigantic: return 4
        case let .custom(level): return level
        }
    }
}
