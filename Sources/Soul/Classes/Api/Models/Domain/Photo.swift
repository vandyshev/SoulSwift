public struct Photo: Codable {
    public let id: String
    public let expiresTime: TimeInterval?
    public let original: Image
    public let thumbnails: [Image]?

    public struct Image: Codable {
        let name: String?
        let url: String
        let width: Double
        let height: Double
    }
}

public extension Photo {
    public var url: String {
        return original.url
    }
}
