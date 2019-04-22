import UIKit

struct MessagePayload {
    let channel: String
    let message: ChatMessage
}

extension MessagePayload: Codable { }
