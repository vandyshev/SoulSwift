import UIKit

protocol MessageMapper {
    func mapToMessage(chatHistoryObject: ChatHistoryObject) -> Message
    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message
    func mapToChatMessage(message: Message, channel: String) -> ChatMessage
}

final class MessageMapperImpl: MessageMapper {

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
                       direction: getDirection(by: chatHistoryObject.userIdentifier),
                       status: chatHistoryObject.readStatus ? .read : .sent)
    }

    func mapToMessage(chatMessage: ChatMessage, channel: String) -> Message {
        let direction = getDirection(by: chatMessage.userId)
        return Message(messageID: chatMessage.messageId,
                       date: chatMessage.timestamp.date,
                       userID: chatMessage.userId,
                       channel: channel,
                       content: chatMessage.content,
                       direction: direction,
                       status: direction == .income ? .sent : .sending)
    }
    
    func mapToChatMessage(message: Message, channel: String) -> ChatMessage {
        var text = ""
        var photoId: String?
        var albumName: String?
        var latitude: Double?
        var longitude: Double?
        var systemData: SystemDataRepresentation?
        switch message.content {
        case let .text(messageText):
            text = messageText
        case let .location(messageLatitude, messageLongitude):
            latitude = messageLatitude
            longitude = messageLongitude
        case let .photo(messagePhotoId, messageAlbumName):
            photoId = messagePhotoId
            albumName = messageAlbumName
        case let .system(data):
            systemData = data
        case .unknown:
            break
        }
        
        return ChatMessage(messageId: message.messageID,
                           userId: message.userID,
                           timestamp: message.date.timeIntervalSince1970,
                           text: text,
                           photoId: photoId,
                           albumName: albumName,
                           latitude: latitude,
                           longitude: longitude,
                           systemData: systemData)
    }
}
