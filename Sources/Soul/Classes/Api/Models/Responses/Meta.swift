public struct Meta: Decodable {
    public let total: Int?
    public let limit: Int?
    public let offset: Int?
    public let since: Int?
    public let viewingSession: String?
    public let uniqueToken: String?
}
