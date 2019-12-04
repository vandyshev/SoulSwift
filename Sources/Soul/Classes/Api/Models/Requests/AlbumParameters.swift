public struct AlbumParameters: Encodable {
    let name: String
    let order: Int?
    let privacy: AlbumParametersPrivacy?
    let parameters: [String: AnyCodable]?
    let expiresTime: TimeInterval?

    public init(name: String,
                order: Int? = nil,
                privacy: AlbumParametersPrivacy? = nil,
                parameters: [String: AnyCodable]? = nil,
                expiresTime: TimeInterval? = nil) {
        self.name = name
        self.order = order
        self.privacy = privacy
        self.parameters = parameters
        self.expiresTime = expiresTime
    }
}

public enum AlbumParametersPrivacy: String, Encodable {
    case `private`
    case `public`
    case unlisted
}
