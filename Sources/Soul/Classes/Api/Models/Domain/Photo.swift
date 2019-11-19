public struct Photo: Codable {
    public let id: String
    let expiresTime: TimeInterval?
    let original: Image
    let thumbnails: [Image]?

    public struct Image: Codable {
        let name: String?
        let url: String
        let width: Double
        let height: Double
    }
}

public extension Photo {
    var url: String {
        return original.url
    }
}
