public struct AlbumParameters: Encodable {
    let name: String?
    let order: Int?
    let privacy: AlbumParametersPrivacy?
    let parameters: [String: AnyCodable]?
    let expiresTime: TimeInterval?
}

public enum AlbumParametersPrivacy: String, Encodable {
    case `private`
    case `public`
    case unlisted
}
