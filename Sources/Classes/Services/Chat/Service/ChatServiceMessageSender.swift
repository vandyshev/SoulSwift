import Foundation

protocol ChatServiceMessageSender {
    @discardableResult
    func sendNewMessage(_ messageToSend: MessageToSend, channel: String) throws -> ChatMessage
    func send(message: ChatMessage, channel: String) throws

    func sendReadEvent(lastReadMessageTimestamp: UnixTimeStamp, channel: String) throws

    func sendDeliveryConfirmationEvent(deliveredMessageId: String,
                                       userIdInMessage: String,
                                       channel: String) throws
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

    func sendNewMessage(_ messageToSend: MessageToSend, channel: String) throws -> ChatMessage {
        guard let message = messageGenerator.createMessage(messageToSend) else {
            throw ChatServiceSenderError.cannotCreateMessage
        }
        try send(message: message, channel: channel)
        return message
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
