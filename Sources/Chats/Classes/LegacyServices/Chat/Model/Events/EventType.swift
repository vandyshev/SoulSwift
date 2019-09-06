import UIKit

/// Enum for events mapping
enum EventType: Equatable {
    case historySync(HistorySyncEvent)
    case messageAcknowledgment(MessageAcknowledgmentEvent)
    case messageFailed(MessageFailedEvent)
    case readEvent(ReadEvent)
    case deliveryConfirmation(DeliveryConfirmationEvent)
}

extension EventType {
    init(_ historySyncEvent: HistorySyncEvent) {
        self = .historySync(historySyncEvent)
    }
    init(_ messageAcknowledgment: MessageAcknowledgmentEvent) {
        self = .messageAcknowledgment(messageAcknowledgment)
    }
    init(_ messageFailed: MessageFailedEvent) {
        self = .messageFailed(messageFailed)
    }
    init(_ readEvent: ReadEvent) {
        self = .readEvent(readEvent)
    }
    init(_ deliveryConfirmation: DeliveryConfirmationEvent) {
        self = .deliveryConfirmation(deliveryConfirmation)
    }
}

extension EventType: Codable {

    enum EventCodingError: Error { case decoding }

    init(from decoder: Decoder) throws {
        if let history = try? HistorySyncEvent(from: decoder) {
            self = .historySync(history)
            return
        }
        if let messageAcknowledgment = try? MessageAcknowledgmentEvent(from: decoder) {
            self = .messageAcknowledgment(messageAcknowledgment)
            return
        }
        if let messageFailed = try? MessageFailedEvent(from: decoder) {
            self = .messageFailed(messageFailed)
            return
        }
        if let readEvent = try? ReadEvent(from: decoder) {
            self = .readEvent(readEvent)
            return
        }
        if let deliveryConfirmation = try? DeliveryConfirmationEvent(from: decoder) {
            self = .deliveryConfirmation(deliveryConfirmation)
            return
        }
        throw EventCodingError.decoding
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case let .historySync(historySync):
            try historySync.encode(to: encoder)
        case let .messageAcknowledgment(messageAcknowledgment):
            try messageAcknowledgment.encode(to: encoder)
        case let .messageFailed(to: messageFailed):
            try messageFailed.encode(to: encoder)
        case let .readEvent(readEvent):
            try readEvent.encode(to: encoder)
        case let .deliveryConfirmation(deliveryConfirmation):
            try deliveryConfirmation.encode(to: encoder)
        }
    }
}
