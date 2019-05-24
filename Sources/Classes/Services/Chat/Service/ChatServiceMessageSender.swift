import Foundation

protocol ChatServiceMessageSender {
    @discardableResult
    func sendNewMessage(_ messageContent: MessageContent, channel: String) throws -> ChatMessage
    func send(message: ChatMessage, channel: String) throws

    func sendReadEvent(lastReadMessageTimestamp: UnixTimeStamp, channel: String) throws

    func sendDeliveryConfirmationEvent(deliveredMessageId: String,
                                       userIdInMessage: String,
                                       channel: String) throws
}

final class ChatServiceMessageSenderImpl: ChatServiceMessageSender {

    private let chatClient: ChatClient
    private let messagesFactory: MessagesFactory
    private let eventFactory: EventFactory
    private let errorService: InternalErrorService

    init(chatClient: ChatClient,
         messagesFactory: MessagesFactory,
         eventFactory: EventFactory,
         errorService: InternalErrorService) {
        self.chatClient = chatClient
        self.messagesFactory = messagesFactory
        self.eventFactory = eventFactory
        self.errorService = errorService
    }

    func sendNewMessage(_ messageContent: MessageContent, channel: String) throws -> ChatMessage {
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageContent)
        } catch {
            handleError(error)
            throw error
        }
        try send(message: message, channel: channel)
        return message
    }

    func send(message: ChatMessage, channel: String) throws {
        let payload = MessagePayload(channel: channel, message: message)
        do {
            try chatClient.sendMessage(payload)
        } catch {
            handleError(error)
            throw error
        }
    }

    func sendDeliveryConfirmationEvent(deliveredMessageId: String,
                                       userIdInMessage: String,
                                       channel: String) throws {
        let event: DeliveryConfirmationEvent
        do {
            event = try eventFactory.createDeliveryConfirmation(deliveredMessageId: deliveredMessageId,
                                                                userIdInMessage: userIdInMessage)
        } catch {
            handleError(error)
            throw error
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    func sendReadEvent(lastReadMessageTimestamp: UnixTimeStamp, channel: String) throws {
        let event: ReadEvent
        do {
            event = try eventFactory.createReadEvent(lastReadMessageTimestamp: lastReadMessageTimestamp)
        } catch {
            handleError(error)
            throw error
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    private func sendEvent(_ eventType: EventType, channel: String) throws {
        let eventPayload = EventPayload(channel: channel, event: eventType)
        do {
            try chatClient.sendMessage(eventPayload)
        } catch {
            handleError(error)
            throw error
        }
    }

    private func handleError(_ error: Error) {
        let apiError: ApiError = .chatSocketError(error)
        errorService.handleError(apiError)
    }
}
