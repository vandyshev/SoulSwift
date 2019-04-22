import Foundation

/// User recives this event after other user has read message.
/// Also user should send this event to SOUL server after message reading.

struct DeliveryConfirmationEvent {
    let time: UnixTimeStamp                     /// `t`  - unix timestamp
    let userIdWhoSent: String                   /// `u` - user id, who sent event
    private let confirmation: ConfirmationEvent /// `d` - confirmation
}

private struct ConfirmationEvent {
    let deliveredMessageId: String /// `id` - delivered message id
    let userId: String             /// `u` - user id
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
        case userIdWhoSent = "u"
        case confirmation = "d"
    }
}
