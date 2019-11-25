public struct Album: Codable {
    public let photoCount: Int?
    public let name: String
    public let privacy: String?
    public let mainPhoto: Photo?
    public let order: Int?
    public let photos: [Photo]?
    public let parameters: [String: AnyCodable]?
}
