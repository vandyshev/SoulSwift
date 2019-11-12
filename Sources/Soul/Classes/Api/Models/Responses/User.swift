public struct User: Decodable {
    public let id: String
    public let parameters: MyUserParameters?
    public let albums: [Album]?
    public let chats: [Chat]?
    public let reactions: Reactions?

    enum CodingKeys: String, CodingKey {
        case id
        case parameters
        case albums
        case chats
        case reactions
    }
}
