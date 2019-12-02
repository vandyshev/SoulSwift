public struct Chat: Decodable {
    public let id: String
    public let myStatus: String?
    public let lastMessage: ChatHistoryObject?
    public let participants: [Participant]?
    public let expiresTime: TimeInterval
    public let channelName: String
    public let flags: Int
    public let creator: String
}
