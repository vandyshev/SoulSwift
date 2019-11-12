public struct Album: Codable {
    let photoCount: Int?
    let name: String?
    let privacy: String?
    let mainPhoto: Photo?
    let order: Int?
    let photos: [Photo]?
    let parameters: [String: AnyCodable]?
}
