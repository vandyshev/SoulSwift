import Foundation

protocol ChatServiceObserver {
    func subscribeOnAllMessages(observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void)
    func subscribeOnAllEvents(observer: AnyObject, onEvent: @escaping (EventPayload) -> Void)

    func subscribeOnMessage(toChannel channel: String, observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void)
    func subscribeOnEvent(toChannel channel: String, observer: AnyObject, onEvent: @escaping (EventPayload) -> Void)

    func unsubscribeFromAllMessage(observer: AnyObject)
    func unsubscribeFromAllEvents(observer: AnyObject)

    func unsubscribeFromMessagesInChannel(_ channel: String, observer: AnyObject)
    func unsubscribeFromEventsInChannel(_ channel: String, observer: AnyObject)
}

final class ChatServiceObserverImpl: ChatServiceObserver {

    private let chatClient: ChatClient

    init(chatClient: ChatClient) {
        self.chatClient = chatClient
        chatClient.subscribe(self) { [weak self] data in
            self?.onPayload(data)
        }
    }

    private let allMessagesObservable = Observable<MessagePayload>()
    private var channelMessageObservables = [String: Observable<MessagePayload>]()

    private let allEventsObservable = Observable<EventPayload>()
    private var channelEventObservables = [String: Observable<EventPayload>]()

    func subscribeOnAllMessages(observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void) {
        allMessagesObservable.subscribe(observer, closure: onMessage)
    }

    func subscribeOnAllEvents(observer: AnyObject, onEvent: @escaping (EventPayload) -> Void) {
        allEventsObservable.subscribe(observer, closure: onEvent)
    }

    func subscribeOnMessage(toChannel channel: String, observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void) {
        let observable = channelMessageObservables[channel] ?? Observable<MessagePayload>()
        observable.subscribe(observer, closure: onMessage)
        channelMessageObservables[channel] = observable
    }

    func subscribeOnEvent(toChannel channel: String, observer: AnyObject, onEvent: @escaping (EventPayload) -> Void) {
        let observable = channelEventObservables[channel] ?? Observable<EventPayload>()
        observable.subscribe(observer, closure: onEvent)
        channelEventObservables[channel] = observable
    }

    func unsubscribeFromAllMessage(observer: AnyObject) {
        allMessagesObservable.unsubscribe(observer)
    }

    func unsubscribeFromAllEvents(observer: AnyObject) {
        allEventsObservable.unsubscribe(observer)
    }

    func unsubscribeFromMessagesInChannel(_ channel: String, observer: AnyObject) {
        if let channelObserver = channelMessageObservables[channel] {
            channelObserver.unsubscribe(observer)
        }
    }

    func unsubscribeFromEventsInChannel(_ channel: String, observer: AnyObject) {
        if let channelObserver = channelEventObservables[channel] {
            channelObserver.unsubscribe(observer)
        }
    }

    private func onPayload(_ data: Data) {
        guard let payload = try? JSONDecoder().decode(ChatPayload.self, from: data) else {
            assertionFailure("impossible message")
            return
        }
        switch payload {
        case let .event(eventPayload):
            onEventPayload(eventPayload)
        case let .message(messagePayload):
            onMessagePayload(messagePayload)
        }
    }

    private func onMessagePayload(_ messagePayload: MessagePayload) {
        allMessagesObservable.broadcast(messagePayload)
        if let observable = channelMessageObservables[messagePayload.channel] {
            observable.broadcast(messagePayload)
        }
    }

    private func onEventPayload(_ eventPayload: EventPayload) {
        allEventsObservable.broadcast(eventPayload)
        if let observable = channelEventObservables[eventPayload.channel] {
            observable.broadcast(eventPayload)
        }
    }
}
