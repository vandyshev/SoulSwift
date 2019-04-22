import Foundation

/// User revievs this event then message have been read by other user.
/// Also user should send this event to server then message has been read.

struct ReadEvent {
    let time: UnixTimeStamp           /// `t`  - unix timestamp
    let userId: String                /// `u`  - user id
    let lastReadMessageTimestamp: UnixTimeStamp /// `rt` - timestamp of the last read message in chat
}

extension ReadEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case userId  = "u"
        case lastReadMessageTimestamp  = "rt"
    }
}
