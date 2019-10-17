import Foundation

/// Handle all messenger interactions
public protocol ChatManager: AnyObject {

    func start() throws
    func finish()

    var isLocalPushNotificationsEnabled: Bool { get set }

    func history(with config: HistoryLoadingConfig,
                 completion: @escaping  (Result<[Message], ApiError>) -> Void)

    func sendMessage(_ messageContent: MessageContent,
                     to channel: String) throws -> Message

    func resendMessage(_ message: Message, to channel: String) throws

    func sendReadEvent(to channel: String, lastMessageDate: Date)

    func subscribe(to channel: String, observer: AnyObject, onMessageEvent: @escaping (MessageEventType) -> Void)
    func subscribe(to channel: String, observer: AnyObject, onMessage: @escaping (Message) -> Void)
    func unsubscribe(from channel: String, observer: AnyObject)

    var connectionStatus: ConnectionStatus { get }
    func subscribeToConnectionStatus(observer: AnyObject, onStatusChange: @escaping (ConnectionStatus) -> Void)
    func unsubscribeFromConnectionStatus(observer: AnyObject)
}

public struct HistoryLoadingConfig {
    public let channel: String
    public let olderThan: Date?
    public let limit: UInt?

    public init(channel: String, olderThan: Date?, limit: UInt?) {
        self.channel = channel
        self.olderThan = olderThan
        self.limit = limit
    }
}

private enum Constants {
    static let defaultLimit = 100
    static let defaultOffset = 0
}

final class ChatManagerImpl: ChatManager {

    var connectionStatus: ConnectionStatus { return chatClient.connectionStatus }
    var isLocalPushNotificationsEnabled: Bool {
        get { return pushManager.isEnabled }
        set { pushManager.isEnabled = newValue }
    }

    private let chatServiceObserver: ChatServiceObserver
    private let chatServiceMessageSender: ChatServiceMessageSender
    private let chatHistoryService: ChatHistoryService
    private let pushManager: ChatLocalPushManager
    private let chatClient: ChatClient
    private let messageMapper: MessageMapper
    private let dateService: DateService

    init(chatServiceObserver: ChatServiceObserver,
         chatServiceMessageSender: ChatServiceMessageSender,
         chatHistoryService: ChatHistoryService,
         chatClient: ChatClient,
         pushManager: ChatLocalPushManager,
         messageMapper: MessageMapper,
         dateService: DateService) {
        self.chatServiceObserver      = chatServiceObserver
        self.chatServiceMessageSender = chatServiceMessageSender
        self.chatHistoryService       = chatHistoryService
        self.chatClient               = chatClient
        self.pushManager              = pushManager
        self.messageMapper            = messageMapper
        self.dateService              = dateService

        handleInputMessages()
    }

    deinit {
        chatServiceObserver.unsubscribeFromAllMessages(observer: self)
    }

    func start() throws {
        try chatClient.start()
    }

    func finish() {
        chatClient.finish()
    }

    private func handleInputMessages() {
        chatServiceObserver.subscribeToAllMessages(observer: self) { [weak self] messagePayload in
            let message = messagePayload.message
            try? self?.chatServiceMessageSender
                .sendDeliveryConfirmationEvent(deliveredMessageId: message.messageId,
                                               userIdInMessage: message.userId,
                                               channel: messagePayload.channel)
        }
    }

    func history(with config: HistoryLoadingConfig,
                 completion: @escaping (Result<[Message], ApiError>) -> Void) {
        let olderThan = config.olderThan ?? Date()
        let adjustedOlderThan = dateService.getAdjustedTimeStamp(from: olderThan)
        let limit = config.limit.flatMap { Int($0) } ?? Constants.defaultLimit
        let chatHistoryConfig = ChatHistoryConfig(limit: limit,
                                                  offset: Constants.defaultOffset,
                                                  beforeTimestamp: adjustedOlderThan,
                                                  afterTimestamp: nil,
                                                  beforeIdentifier: nil,
                                                  afterIdentifer: nil,
                                                  beforeMessageIdentifier: nil,
                                                  afterMessageIdentifer: nil)
        chatHistoryService.loadHistory(channel: config.channel,
                                       historyConfig: chatHistoryConfig) { [weak self] result in
            guard let stelf = self else { return }

            switch result {
            case let .success(history):
                let messages = history.map { stelf.messageMapper.mapToMessage(chatHistoryObject: $0) }
                completion(.success(messages))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func sendMessage(_ messageContent: MessageContent,
                     to channel: String) throws -> Message {
        let chatMessage = try chatServiceMessageSender.sendNewMessage(messageContent, channel: channel)
        return messageMapper.mapToMessage(chatMessage: chatMessage, channel: channel)
    }

    func resendMessage(_ message: Message, to channel: String) throws {
        let chatMessage = messageMapper.mapToChatMessage(message: message, channel: channel)
        try chatServiceMessageSender.send(message: chatMessage, channel: channel)
    }

    func sendReadEvent(to channel: String, lastMessageDate: Date) {
        let timestamp = DateHelper.timestamp(from: lastMessageDate)
        try? chatServiceMessageSender.sendReadEvent(lastReadMessageTimestamp: timestamp, channel: channel)
    }

    func subscribe(to channel: String, observer: AnyObject, onMessage: @escaping (Message) -> Void) {
        chatServiceObserver.subscribeToMessages(inChannel: channel,
                                                observer: observer) { [weak self] messagePayload in
            guard let stelf = self else { return }
            let message = stelf.messageMapper.mapToMessage(chatMessage: messagePayload.message,
                                                           channel: messagePayload.channel)
            onMessage(message)
        }
        chatServiceObserver.subscribeToEvents(inChannel: channel,
                                              observer: observer) { [weak self] event in
            let historySync: HistorySyncEvent? = {
                guard case let .historySync(historySync) = event.event else { return nil }
                return historySync
            }()
            guard let message = historySync?.message, let stelf = self else { return }
            let mappedMessage = stelf.messageMapper.mapToMessage(chatMessage: message,
                                                                 channel: channel)
            onMessage(mappedMessage)
        }
    }

    func subscribe(to channel: String, observer: AnyObject, onMessageEvent: @escaping (MessageEventType) -> Void) {
        chatServiceObserver.subscribeToEvents(inChannel: channel,
                                              observer: observer) { eventPayload in
            switch eventPayload.event {
            case .messageFailed(let event):
                onMessageEvent(.failed(messageId: event.messageId))

            case .messageAcknowledgment(let event):
                onMessageEvent(.ack(messageId: event.messageId))

            case .deliveryConfirmation(let event):
                onMessageEvent(.delivered(messageId: event.deliveredMessageId))

            case .readEvent(let event):
                onMessageEvent(.read(timestamp: event.lastReadMessageTimestamp))

            case .historySync:
                break
            }
        }
    }

    func unsubscribe(from channel: String, observer: AnyObject) {
        chatServiceObserver.unsubscribeFromMessagesInChannel(channel, observer: observer)
        chatServiceObserver.unsubscribeFromEventsInChannel(channel, observer: observer)
    }

    func subscribeToConnectionStatus(observer: AnyObject, onStatusChange: @escaping (ConnectionStatus) -> Void) {
        chatClient.subscribeToConnectionStatus(observer, closure: onStatusChange)
    }

    func unsubscribeFromConnectionStatus(observer: AnyObject) {
        chatClient.unsubscribeFromConnectionStatus(observer)
    }
}
