public struct AlbumParameters: Encodable {
    let name: String?
    let order: Int?
    let privacy: AlbumPrivacy?
    let parameters: AlbumCustomParameters?
    let expiresTime: TimeInterval?
}

public enum AlbumPrivacy: String, Encodable {
    case `private`
    case `public`
    case unlisted
}

public struct AlbumCustomParameters: Encodable {

}
