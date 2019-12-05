import Foundation

/// User send this event then he make a screenshot of chat
struct SecurityEvent: Equatable {

    /// `t`  - unix timestamp
    let time: UnixTimeStamp

    /// `u`  - user id
    let userId: String

    /// `security` - security type 
    let security: SecurityEventType
}

enum SecurityEventType: String, Codable {
    case screenshot
}

extension SecurityEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case userId = "u"
        case security
    }
}
