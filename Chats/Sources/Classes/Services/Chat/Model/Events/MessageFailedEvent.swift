import Foundation

/// This event mean that user message haven't passed validation.
struct MessageFailedEvent: Equatable {

    /// `t` - unix timestamp
    let time: UnixTimeStamp

    /// `f` - failed event
    private let failedEvent: FailedEvent
}

extension MessageFailedEvent {
    init(time: UnixTimeStamp, messageId: String, userId: String, error: String) {
        self.time = time
        self.failedEvent = FailedEvent(messageId: messageId, userId: userId, error: error)
    }
}

extension MessageFailedEvent {
    var messageId: String { return failedEvent.messageId }
    var userId: String { return failedEvent.userId }
    var error: String { return failedEvent.error }
}

private struct FailedEvent: Equatable {

    /// `id` - message id
    let messageId: String

    /// `u`  - user id
    let userId: String

    /// 'r'  - error description
    let error: String
}

extension MessageFailedEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case failedEvent = "f"
    }
}

extension FailedEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case userId  = "u"
        case error  = "r"
    }
}
