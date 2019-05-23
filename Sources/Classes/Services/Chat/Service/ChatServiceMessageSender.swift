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
    private let errorService: InternalErrorService

    init(chatClient: ChatClient,
         messagesGenerator: MessagesGenerator,
         eventGenerator: EventGenerator,
         errorService: InternalErrorService) {
        self.chatClient = chatClient
        self.messageGenerator = messagesGenerator
        self.eventGenerator = eventGenerator
        self.errorService = errorService
    }

    func sendNewMessage(_ messageContent: MessageContent, channel: String) throws -> ChatMessage {
        guard let message = messageGenerator.createMessage(messageContent) else {
            let error = ChatServiceSenderError.cannotCreateMessage
            handleError(error)
            throw error
        }
        try send(message: message, channel: channel)
        return message
    }

    func send(message: ChatMessage, channel: String) throws {
        let payload = MessagePayload(channel: channel, message: message)
        let sended = chatClient.sendMessage(payload)
        if !sended {
            let error = ChatServiceSenderError.cannotSendMessage
            handleError(error)
            throw error
        }
    }

    func sendDeliveryConfirmationEvent(deliveredMessageId: String,
                                       userIdInMessage: String,
                                       channel: String) throws {
        guard let event = eventGenerator.createDeliveryConfirmation(deliveredMessageId: deliveredMessageId,
                                                                    userIdInMessage: userIdInMessage) else {
            let error = ChatServiceSenderError.cannotCreateEvent
            handleError(error)
            throw error
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    func sendReadEvent(lastReadMessageTimestamp: UnixTimeStamp, channel: String) throws {
        guard let event = eventGenerator.createReadEvent(lastReadMessageTimestamp: lastReadMessageTimestamp) else {
            let error = ChatServiceSenderError.cannotCreateEvent
            handleError(error)
            throw error
        }
        let eventType = EventType(event)
        try sendEvent(eventType, channel: channel)
    }

    private func sendEvent(_ eventType: EventType, channel: String) throws {
        let eventPayload = EventPayload(channel: channel, event: eventType)
        let sended = chatClient.sendMessage(eventPayload)
        if !sended {
            let error = ChatServiceSenderError.cannotSendEvent
            handleError(error)
            throw error
        }
    }

    private func handleError(_ error: ChatServiceSenderError) {
        let apiError: ApiError = .chatSocketError(error)
        errorService.handleError(apiError)
    }
}
