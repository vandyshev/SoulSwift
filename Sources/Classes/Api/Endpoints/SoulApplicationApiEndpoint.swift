enum SoulApplicationApiEndpoint {
    case features
    case constants(namespace: String)
}

extension SoulApplicationApiEndpoint: SoulApiEndpoint {
    var path: String {
        switch self {
        case .features:
            return "/application/features"
        case .constants(let namespace):
            return "/application/constants/\(namespace)"
        }
    }
}
