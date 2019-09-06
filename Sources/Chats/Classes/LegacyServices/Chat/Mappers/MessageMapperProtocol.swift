import UIKit

protocol MessageMapperProtocol {
    func mapToMessage(chatHistoryObject: ChatHistoryObject) -> Message
    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message
}

final class MessageMapper: MessageMapperProtocol {

    private let storage: Storage

    private var currentUserIdentifier: String? {
        return storage.userID
    }

    init(storage: Storage) {
        self.storage = storage
    }

    private func getDirection(by userIdentifier: String) -> MessageDirection {
        guard let currentUserIdentifier = currentUserIdentifier else { return .unknown }
        return userIdentifier == currentUserIdentifier ? .outgoing  : .income
    }

    func mapToMessage(chatHistoryObject: ChatHistoryObject) -> Message {
        let historyMessage = chatHistoryObject.message
        return Message(messageID: historyMessage.messageId,
                       date: historyMessage.timestamp.date,
                       userID: historyMessage.userId,
                       channel: chatHistoryObject.channel,
                       content: historyMessage.content,
                       direction: getDirection(by: chatHistoryObject.userIdentifier))
    }

    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message {

        return Message(messageID: chatMessage.messageId,
                       date: chatMessage.timestamp.date,
                       userID: chatMessage.userId,
                       channel: channel,
                       content: chatMessage.content,
                       direction: getDirection(by: chatMessage.userId))
    }
}
