import UIKit

/// Public message representation
public struct Message {
    public let messageID: String
    public let date: Date
    public let userID: String
    public let channel: String
    public let content: MessageContent
    public let direction: MessageDirection
}

public enum MessageDirection {
    case outgoing
    case income
    case unknown
}
