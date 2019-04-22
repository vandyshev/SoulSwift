import UIKit

struct MessagePayload {
    let channel: String
    let message: ChatMessage
}

extension MessagePayload: Codable {
    enum CodingKeys: String, CodingKey {
        case channel
        case message
    }
}
