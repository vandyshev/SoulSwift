public enum Gender: Codable {
    // SoulSwift: Возможно стоит удалить none
    case none
    case male
    case female

    enum CodingKeys: String, CodingKey {
        case gender
    }

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "M", "m":
            self = .male
        case "F", "f":
            self = .female
        default:
            self = .none
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .male:
            try container.encode("m")
        case .female:
            try container.encode("f")
        default:
            try container.encode("none")
        }
    }
}
