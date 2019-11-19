public struct Chat: Decodable {
    public let id: String
    public let myStatus: String?
    public let lastMessage: Message?
    public let participants: [Participant]?
    public let expiresTime: TimeInterval
    public let channelName: String
    public let flags: Int
    public let creator: String

    public struct Participant: Decodable {
        public let userId: String?
        public let status: String?
    }

    public struct Message: Decodable {
        public let userId: String?
        public let sentAt: String?
        public let readStatus: Bool?
        public let messageId: String?
        public let message: MessageContent?
        public let id: Int?
        public let channel: String?

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case sentAt = "sent_at"
            case readStatus = "read_status"
            case messageId = "message_id"
            case message
            case id
            case channel
        }

        public struct MessageContent: Decodable {
            public let user: String
            public let message: String
            public let time: TimeInterval?
            public let id: String

            enum CodingKeys: String, CodingKey {
                case user = "u"
                case message = "m"
                case time = "t"
                case id = "id"
            }
        }
    }
}
