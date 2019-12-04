public struct ReactionParameters: Encodable {
    public let value: String
    public let expiresTime: TimeInterval?

    public init(value: String, expiresTime: TimeInterval? = nil) {
        self.value = value
        self.expiresTime = expiresTime
    }
}
