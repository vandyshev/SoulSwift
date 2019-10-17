import UIKit

/// Public message representation
public struct Message {
    public let messageID: String
    public let date: Date
    public let userID: String
    public let channel: String
    public let content: MessageContent
    public let direction: MessageDirection
    public let status: MessageStatus
    
    public init(messageID: String,
                date: Date,
                userID: String,
                channel: String,
                content: MessageContent,
                direction: MessageDirection,
                status: MessageStatus) {
        self.messageID = messageID
        self.date = date
        self.userID = userID
        self.channel = channel
        self.content = content
        self.direction = direction
        self.status = status
    }
}

public enum MessageDirection {
    case outgoing
    case income
    case unknown
}

public enum MessageStatus {
    case failed
    case sending
    case sent
    case read
}
