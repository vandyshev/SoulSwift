import Foundation

public struct ChatHistoryConfig {
    let limit: Int
    let offset: Int
    let beforeTimestamp: UnixTimeStamp?
    let afterTimestamp: UnixTimeStamp?
    let beforeIdentifier: String?
    let afterIdentifer: String?
    let beforeMessageIdentifier: String?
    let afterMessageIdentifer: String?
}

extension ChatHistoryConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case beforeTimestamp         = "before"
        case afterTimestamp          = "after"
        case beforeIdentifier        = "before_id"
        case afterIdentifer          = "after_id"
        case beforeMessageIdentifier = "before_message_id"
        case afterMessageIdentifer   = "after_message_id"
    }
}
