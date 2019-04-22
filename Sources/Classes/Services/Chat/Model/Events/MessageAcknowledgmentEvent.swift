import Foundation

/// This event mean that message was accepted by SOUL server

struct MessageAcknowledgmentEvent {
    let time: UnixTimeStamp                         /// `t` - unix timestamp // TODO: check int or double
    private let acknowledgment: AcknowledgmentEvent /// `a` - acknowledgment
}

extension MessageAcknowledgmentEvent {
    var messageId: String {
        return acknowledgment.messageId
    }
    var userId: String {
        return acknowledgment.messageId
    }
}

private struct AcknowledgmentEvent {
    let messageId: String /// `id` - message id
    let userId: String    /// `u`  - user id
}

extension MessageAcknowledgmentEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time           = "t"
        case acknowledgment = "a"
    }
}

extension AcknowledgmentEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case userId    = "u"
    }
}
