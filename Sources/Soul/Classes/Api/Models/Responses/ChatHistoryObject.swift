import Foundation

/// Chat History Object
public struct ChatHistoryObject {
    /// `id` - chat history object identifier
    public let identifier: Int

    /// `user_id` - user identifier
    public let userIdentifier: String

    /// `message_id` - message identifier
    public let messageID: String

    /// `channel` - channel identifier
    public let channel: String

    /// `sent_at` - date when message was sent
    public let sentAt: Date

    /// `message` - message object
    public let message: ChatMessage

    /// `read_status` - is message read
    public let isRead: Bool
}

extension ChatHistoryObject: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier     = "id"
        case userIdentifier = "user_id"
        case messageID      = "message_id"
        case channel        = "channel"
        case sentAt         = "sent_at"
        case message        = "message"
        case isRead         = "read_status"
    }
}

extension ChatHistoryObject {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.userIdentifier = try container.decode(String.self, forKey: .userIdentifier)
        self.messageID = try container.decode(String.self, forKey: .messageID)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.message = try container.decode(ChatMessage.self, forKey: .message)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)

        let sentAtRaw = try container.decode(String.self, forKey: .sentAt)
        if let iso8601FullDate = DateFormatter.iso8601Full.date(from: sentAtRaw) {
            self.sentAt = iso8601FullDate
        } else if let iso8601WithoutMillisecondsDate = DateFormatter.iso8601WithoutMilliseconds.date(from: sentAtRaw) {
            self.sentAt = iso8601WithoutMillisecondsDate
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.sentAt], debugDescription: "Wrong data format"))
        }
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        makeDateFormatter(with: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
    }()
    static let iso8601WithoutMilliseconds: DateFormatter = {
        makeDateFormatter(with: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }()
    private static func makeDateFormatter(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
       formatter.dateFormat = dateFormat
       formatter.calendar = Calendar(identifier: .iso8601)
       formatter.timeZone = TimeZone(secondsFromGMT: 0)
       formatter.locale = Locale(identifier: "en_US_POSIX")
       return formatter
    }
}
