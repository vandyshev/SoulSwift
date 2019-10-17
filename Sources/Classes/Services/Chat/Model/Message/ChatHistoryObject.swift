import Foundation

/// Chat History Object
public struct ChatHistoryObject {
    /// `id` - chat history object identifier
    let identifier: Int

    /// `user_id` - user identifier
    let userIdentifier: String

    /// `message_id` - message identifier
    let messageID: String

    /// `channel` - channel identifier
    let channel: String

    /// `sent_at` - date when message was sent
    let sentAt: Date

    /// `message` - message object
    let message: ChatMessage

    /// `read_status` - is message read
    let readStatus: Bool
}

extension ChatHistoryObject: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier     = "id"
        case userIdentifier = "user_id"
        case messageID      = "message_id"
        case channel        = "channel"
        case sentAt         = "sent_at"
        case message        = "message"
        case readStatus     = "read_status"
    }
}
