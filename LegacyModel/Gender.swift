import Foundation

enum Gender {
    case none, male, female

    func opposite() -> Gender {
        switch self {
        case .female:
            return .male
        case .male:
            return .female
        default:
            return .none
        }
    }

    var code: String {
        switch self {
        case .female:
            return "F"
        case .male:
            return "M"
        default:
            return "N"
        }
    }

    static func forString(_ string: String?) -> Gender {
        switch string {
        case "f", "F":
            return .female
        case "m", "M":
            return .male
        default:
            return .none
        }
    }
}

extension Gender {
    var isMale: Bool {
        guard case .male = self else {
            return false
        }
        return true
    }
    var isFemale: Bool {
        guard case .female = self else {
            return false
        }
        return true
    }
}

extension Gender: Equatable { }
