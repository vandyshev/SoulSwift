import Foundation

/// This event mean that message was accepted by SOUL server

struct MessageAcknowledgmentEvent: Equatable {

    /// `t` - unix timestamp
    let time: UnixTimeStamp

    /// `a` - acknowledgment
    private let acknowledgment: AcknowledgmentEvent
}

extension MessageAcknowledgmentEvent {
    init(time: UnixTimeStamp, messageId: String, userId: String) {
        self.time = time
        self.acknowledgment = AcknowledgmentEvent(messageId: messageId, userId: userId)
    }
}

extension MessageAcknowledgmentEvent {
    var messageId: String {
        return acknowledgment.messageId
    }
    var userId: String {
        return acknowledgment.messageId
    }
}

private struct AcknowledgmentEvent: Equatable {

    /// `id` - message id
    let messageId: String

    /// `u`  - user id
    let userId: String
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
