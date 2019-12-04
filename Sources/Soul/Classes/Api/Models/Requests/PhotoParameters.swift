public struct PhotoParameters: Encodable {
    public let order: Int?
    public let mainPhoto: Bool?
    public let album: String?
    public let expiresTime: TimeInterval?

    public init(order: Int? = nil,
                mainPhoto: Bool? = nil,
                album: String? = nil,
                expiresTime: TimeInterval? = nil) {
        self.order = order
        self.mainPhoto = mainPhoto
        self.album = album
        self.expiresTime = expiresTime
    }
}
