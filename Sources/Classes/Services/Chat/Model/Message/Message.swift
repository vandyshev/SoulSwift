import UIKit

public struct Message {
    public let messageID: String
    public let date: Date
    public let userID: String
    public let text: String
    public let channel: String
    public let direction: MessageDirection
}

public enum MessageDirection {
    case outgoing
    case income
    case unknown
}
