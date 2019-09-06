import Foundation

/// User revievs this event then message have been read by other user.
/// Also user should send this event to server then message has been read.
struct ReadEvent: Equatable {

    /// `t`  - unix timestamp
    let time: UnixTimeStamp

    /// `u`  - user id
    let userId: String

    /// `rt` - timestamp of the last read message in chat
    let lastReadMessageTimestamp: UnixTimeStamp
}

extension ReadEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case userId  = "u"
        case lastReadMessageTimestamp  = "rt"
    }
}
