import Foundation

protocol ChatServiceMessageSender {
    // TODO: refactor without throw and return results
    @discardableResult
    func sendMessage(withText text: String, channel: String) throws
    @discardableResult
    func sendMessage(withLat lat: Double, lng: Double, channel: String) throws
    @discardableResult
    func sendMessage(with photoId: String, albumName: String, channel: String) throws
    func send(message: ChatMessage, channel: String) throws
}

enum ChatServiceSenderError: Error {
    case cannotCreateMessage
    case cannotSendMessage
    case cannotCreateEvent
    case cannotSendEvent
}

final class ChatServiceMessageSenderImpl: ChatServiceMessageSender {

    private let chatClient: ChatClient
    private let messageGenerator: MessagesGenerator
    private let eventGenerator: EventGenerator

    init(chatClient: ChatClient, messagesGenerator: MessagesGenerator, eventGenerator: EventGenerator) {
        self.chatClient = chatClient
        self.messageGenerator = messagesGenerator
        self.eventGenerator = eventGenerator
    }

    func sendMessage(withText text: String, channel: String) throws {
        guard let message = messageGenerator.createTextMessage(text) else {
            throw ChatServiceSenderError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
    }

    func sendMessage(withLat lat: Double, lng: Double, channel: String) throws {
        guard let message = messageGenerator.createGeoMessage(lat: lat, lng: lng) else {
            throw ChatServiceSenderError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
    }

    func sendMessage(with photoId: String, albumName: String, channel: String) throws {
        guard let message = messageGenerator.createPhotoMessage(photoId: photoId, albumName: albumName) else {
            throw ChatServiceSenderError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
    }

    func send(message: ChatMessage, channel: String) throws {
        let payload = MessagePayload(channel: channel, message: message)
        let sended = chatClient.sendMessage(payload)
        if !sended {
            throw ChatServiceSenderError.cannotSendMessage
        }
    }

    func sendDeliveryConfirmationEvent(deliveredMessageId: String,
                                       userIdInMessage: String,
                                       channel: String) throws {
        guard let event = eventGenerator.createDeliveryConfirmation(deliveredMessageId: deliveredMessageId,
                                                                    userIdInMessage: userIdInMessage) else {
            throw ChatServiceSenderError.cannotCreateEvent
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    func sendReadEvent(lastReadMessageTimestamp: UnixTimeStamp, channel: String) throws {
        guard let event = eventGenerator.createReadEvent(lastReadMessageTimestamp: lastReadMessageTimestamp) else {
            throw ChatServiceSenderError.cannotCreateEvent
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    private func sendEvent(_ eventType: EventType, channel: String) throws {
        let eventPayload = EventPayload(channel: channel, event: eventType)
        let sended = chatClient.sendMessage(eventPayload)
        if !sended {
            throw ChatServiceSenderError.cannotSendEvent
        }
    }
}
