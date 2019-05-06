import UIKit

protocol MessageMapper {
    func mapToMessage(chatHistoryObject: ChatHistoryObject) -> Message
    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message
}

final class MessageMapperImpl: MessageMapper {
    func mapToMessage(chatHistoryObject: ChatHistoryObject) -> Message {
        let historyMessage = chatHistoryObject.message
        return Message(messageID: historyMessage.messageId,
                       date: historyMessage.timestamp.date,
                       userID: historyMessage.userId,
                       text: historyMessage.text,
                       channel: chatHistoryObject.channel)
    }

    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message {
        return Message(messageID: chatMessage.messageId,
                       date: chatMessage.timestamp.date,
                       userID: chatMessage.userId,
                       text: chatMessage.text,
                       channel: channel)
    }
}
