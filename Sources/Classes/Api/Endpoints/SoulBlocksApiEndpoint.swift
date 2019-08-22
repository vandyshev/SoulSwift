enum SoulBlocksApiEndpoint {
    case soulKoth
}

extension SoulBlocksApiEndpoint: SoulApiEndpoint {
    var path: String {
        switch self {
        case .soulKoth:
            return "/blocks/soul/koth/"
        }
    }
}
