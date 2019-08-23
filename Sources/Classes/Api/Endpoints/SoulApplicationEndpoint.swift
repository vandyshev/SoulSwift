enum SoulApplicationEndpoint {
    case features
    case constants(namespace: String)
}

extension SoulApplicationEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .features:
            return "/application/features"
        case .constants(let namespace):
            return "/application/constants/\(namespace)"
        }
    }
}
