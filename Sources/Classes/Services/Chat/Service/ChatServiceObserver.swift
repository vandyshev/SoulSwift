import Foundation

protocol ChatServiceObserver {
    func subscribeOnAllMessages(observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void)
    func subscribeOnAllEvents(observer: AnyObject, onEvent: @escaping (EventPayload) -> Void)

    func subscribeOnMessage(toChannel channel: String, observer: Any, onMessage: @escaping (MessagePayload) -> Void)
    func subscribeOnEvent(toChannel channel: String, observer: Any, onEvent: @escaping (EventPayload) -> Void)

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
    private let channelMessageObservers = [String: Observable<MessagePayload>]()

    private let allEventsObservable = Observable<EventPayload>()
    private let channelEventObservers = [String: Observable<EventPayload>]()

    func subscribeOnAllMessages(observer: AnyObject, onMessage: @escaping (MessagePayload) -> Void) {
        allMessagesObservable.subscribe(observer, closure: onMessage)
    }

    func subscribeOnAllEvents(observer: AnyObject, onEvent: @escaping (EventPayload) -> Void) {
        allEventsObservable.subscribe(observer, closure: onEvent)
    }

    func subscribeOnMessage(toChannel channel: String, observer: Any, onMessage: @escaping (MessagePayload) -> Void) {
        let observer = channelMessageObservers[channel] ?? Observable<MessagePayload>()
        observer.subscribe(observer, closure: onMessage)
    }

    func subscribeOnEvent(toChannel channel: String, observer: Any, onEvent: @escaping (EventPayload) -> Void) {
        let observer = channelEventObservers[channel] ?? Observable<EventPayload>()
        observer.subscribe(observer, closure: onEvent)
    }

    func unsubscribeFromAllMessage(observer: AnyObject) {
        allMessagesObservable.unsubscribe(observer)
    }

    func unsubscribeFromAllEvents(observer: AnyObject) {
        allEventsObservable.unsubscribe(observer)
    }

    func unsubscribeFromMessagesInChannel(_ channel: String, observer: AnyObject) {
        if let channelObserver = channelMessageObservers[channel] {
            channelObserver.unsubscribe(observer)
        }
    }

    func unsubscribeFromEventsInChannel(_ channel: String, observer: AnyObject) {
        if let channelObserver = channelEventObservers[channel] {
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
        if let observable = channelMessageObservers[messagePayload.channel] {
            observable.broadcast(messagePayload)
        }
    }

    private func onEventPayload(_ eventPayload: EventPayload) {
        allEventsObservable.broadcast(eventPayload)
        if let observable = channelEventObservers[eventPayload.channel] {
            observable.broadcast(eventPayload)
        }
    }
}
