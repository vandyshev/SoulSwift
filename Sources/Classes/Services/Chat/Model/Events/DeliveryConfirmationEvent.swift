import Foundation

/// User recives this event after other user has read message.
/// Also user should send this event to SOUL server after message reading.
struct DeliveryConfirmationEvent: Equatable {

    /// `t`  - unix timestamp
    let time: UnixTimeStamp

    /// `u` - user id, who sent event
    let senderId: String

    /// `d` - confirmation
    private let confirmation: ConfirmationEvent
}

extension DeliveryConfirmationEvent {
    init(time: UnixTimeStamp, senderId: String, deliveredMessageId: String, userId: String) {
        self.time = time
        self.senderId = senderId
        self.confirmation = ConfirmationEvent(deliveredMessageId: deliveredMessageId,
                                              userId: userId)
    }
}

private struct ConfirmationEvent: Equatable {

    /// `id` - delivered message id
    let deliveredMessageId: String

    /// `u` - user id
    let userId: String
}

extension DeliveryConfirmationEvent {
    var deliveredMessageId: String { return confirmation.deliveredMessageId }
    var userId: String { return confirmation.userId }
}

extension ConfirmationEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case deliveredMessageId = "id"
        case userId  = "u"
    }
}

extension DeliveryConfirmationEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case senderId = "u"
        case confirmation = "d"
    }
}
