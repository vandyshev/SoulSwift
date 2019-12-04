public struct Endpoint: Decodable {
    public let type: String?
    public let uri: EndpointUri

    public init(type: String?, uri: EndpointUri) {
        self.type = type
        self.uri = uri
    }
}

public enum EndpointUri: String, Decodable {
    case recommendations = "/users/recommendations"
    case koth = "/blocks/soul/koth/"
}
