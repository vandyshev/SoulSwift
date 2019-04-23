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
    private let eventGenerator: EventGenerator

    init(chatClient: ChatClient, messagesGenerator: MessagesGenerator, eventGenerator: EventGenerator) {
        self.chatClient = chatClient
        self.messageGenerator = messagesGenerator
        self.eventGenerator = eventGenerator

        self.chatClient.subscribe(self) { [weak self] data in
            self?.onPayload(data)
        }
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

    func onPayload(_ data: Data) {
        guard let payload = try? JSONDecoder().decode(ChatPayload.self, from: data) else {
            assertionFailure("impossible message")
            return
        }
        print("payload \(payload)")
    }
}
