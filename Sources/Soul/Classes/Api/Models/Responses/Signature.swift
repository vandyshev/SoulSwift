public struct Signature: Decodable {
    public let nonce: String
    public let timestamp: Int
    public let keyId: String
    public let signature: String
}
