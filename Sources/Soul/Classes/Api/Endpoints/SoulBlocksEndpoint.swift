enum SoulBlocksEndpoint {
    case soulKoth
}

extension SoulBlocksEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .soulKoth:
            return "/blocks/soul/koth/"
        }
    }
}
