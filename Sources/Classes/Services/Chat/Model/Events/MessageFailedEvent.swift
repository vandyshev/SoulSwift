import Foundation

/// This event mean that user message haven't passed validation.

struct MessageFailedEvent {
    let time: UnixTimeStamp              /// `t` - unix timestamp // TODO: check int or double
    private let failedEvent: FailedEvent /// `f` - failed event
}

extension MessageFailedEvent {
    var messageId: String { return failedEvent.messageId }
    var userId: String { return failedEvent.userId }
    var error: String { return failedEvent.error }
}

private struct FailedEvent {
    let messageId: String /// `id` - message id
    let userId: String    /// `u`  - user id
    let error: String     /// 'r'  - error description
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
