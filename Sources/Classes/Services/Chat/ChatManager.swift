import Foundation

/// Handle all messenger interactions
public protocol ChatManager: AnyObject {
    func history(channel: String, olderThan date: Date?, completion: @escaping  (Result<[Message], Error>) -> Void)
    func sendMessage(_ messageForSend: MessageToSend, to channel: String, completion: @escaping (Result<Message, Error>) -> Void)
    func sendReadEvent(to channel: String, lastMessageDate: Date)
    func subscribe(to channel: String, observer: AnyObject, onMessage: @escaping (Message) -> Void)
    func unsubscribe(from channel: String, observer: AnyObject)
}

private enum Constants {
    static let defaultLimit = 100
    static let defaultOffset = 0
}

final class ChatManagerImpl: ChatManager {

    private let chatServiceObserver: ChatServiceObserver
    private let chatServiceMessageSender: ChatServiceMessageSender
    private let chatHistoryService: ChatHistoryService
    private let messageMapper: MessageMapper

    init(chatServiceObserver: ChatServiceObserver,
         chatServiceMessageSender: ChatServiceMessageSender,
         chatHistoryService: ChatHistoryService,
         messageMapper: MessageMapper) {
        self.chatServiceObserver      = chatServiceObserver
        self.chatServiceMessageSender = chatServiceMessageSender
        self.chatHistoryService       = chatHistoryService
        self.messageMapper            = messageMapper
    }

    func history(channel: String, olderThan date: Date?, completion: @escaping (Result<[Message], Error>) -> Void) {
        let olderThan = date ?? Date()
        let chatHistoryConfig = ChatHistoryConfig(limit: Constants.defaultLimit,
                                                  offset: Constants.defaultOffset,
                                                  beforeTimestamp: DateHelper.timestamp(from: olderThan),
                                                  afterTimestamp: nil,
                                                  beforeIdentifier: nil,
                                                  afterIdentifer: nil,
                                                  beforeMessageIdentifier: nil,
                                                  afterMessageIdentifer: nil)
        chatHistoryService.loadHistory(channel: channel, historyConfig: chatHistoryConfig) { [weak self] result in
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

    func sendMessage(_ messageToSend: MessageToSend, to channel: String, completion: @escaping (Result<Message, Error>) -> Void) {
        do {
            let chatMessage = try chatServiceMessageSender.sendNewMessage(messageToSend, channel: channel)
            let message = messageMapper.mapToMessage(chatMessage: chatMessage, channel: channel)
            completion(.success(message))
        } catch {
            completion(.failure(error))
        }
    }

    func sendReadEvent(to channel: String, lastMessageDate: Date) {
        let timestamp = DateHelper.timestamp(from: lastMessageDate)
        try? chatServiceMessageSender.sendReadEvent(lastReadMessageTimestamp: timestamp, channel: channel)
    }

    func subscribe(to channel: String, observer: AnyObject, onMessage: @escaping (Message) -> Void) {
        chatServiceObserver.subscribeOnMessage(toChannel: channel, observer: observer) { [weak self] messagePayload in
            guard let stelf = self else { return }
            let message = stelf.messageMapper.mapToMessage(chatMessage: messagePayload.message, channel: messagePayload.channel)
            onMessage(message)
        }
    }

    func unsubscribe(from channel: String, observer: AnyObject) {
        chatServiceObserver.unsubscribeFromMessagesInChannel(channel, observer: observer)
    }
}
