import UIKit

/// Chat Message Payload. It contains channel name and message
struct MessagePayload: Equatable, Codable {

    /// `channel` - channel name
    let channel: String

    /// `message` - chat message
    let message: ChatMessage
}
