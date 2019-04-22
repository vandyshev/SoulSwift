import UIKit

public protocol ChatService {

    @discardableResult
    func sendMessage(withText text: String, channel: String) throws -> ChatMessage? // TODO: think about throws
    @discardableResult
    func sendMessage(withLat lat: Double, lng: Double, channel: String) throws -> ChatMessage? // TODO: think about throws
    @discardableResult
    func sendMessage(with photoId: String, albumName: String, channel: String) throws -> ChatMessage? // TODO: think about throws
    func send(message: ChatMessage, channel: String) throws // TODO: think about throws

}

enum ChatServiceError: Error {
    case cannotCreateMessage
    case cannotSendMessage
}

final class ChatServiceImpl: ChatService {

    private let chatClient: ChatClient
    private let messageGenerator: MessagesGenerator

    init(chatClient: ChatClient, messagesGenerator: MessagesGenerator) {
        self.chatClient = chatClient
        self.messageGenerator = messagesGenerator
    }

    func sendMessage(withText text: String, channel: String) throws -> ChatMessage? {
        guard let message = messageGenerator.createTextMessage(text) else {
            throw ChatServiceError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
        return message
    }

    func sendMessage(withLat lat: Double, lng: Double, channel: String) throws -> ChatMessage? {
        guard let message = messageGenerator.createGeoMessage(lat: lat, lng: lng) else {
            throw ChatServiceError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
        return message
    }

    func sendMessage(with photoId: String, albumName: String, channel: String) throws -> ChatMessage? {
        guard let message = messageGenerator.createPhotoMessage(photoId: photoId, albumName: albumName) else {
            throw ChatServiceError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
        return message
    }
    
    func send(message: ChatMessage, channel: String) throws {
        let payload = MessagePayload(channel: channel, message: message)
        let sended = chatClient.sendMessage(payload)
        if !sended {
            throw ChatServiceError.cannotSendMessage
        }
    }
}
