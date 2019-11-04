import UIKit

protocol EventFactory {
    func createReadEvent(lastReadMessageTimestamp: UnixTimeStamp) throws -> ReadEvent
    func createDeliveryConfirmation(deliveredMessageId: String, userIdInMessage: String) throws -> DeliveryConfirmationEvent
}

enum EventFactoryError: Error {
    case cannotCreateEvent
}

extension EventFactoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotCreateEvent:
            return "Cannot create event"
        }
    }
}

final class EventFactoryImpl: EventFactory {

    private let storage: Storage
    private let dateService: DateService

    init(storage: Storage, dateService: DateService) {
        self.storage = storage
        self.dateService = dateService
    }

    func createReadEvent(lastReadMessageTimestamp: UnixTimeStamp) throws -> ReadEvent {

        guard let userId = storage.userID else {
            throw EventFactoryError.cannotCreateEvent
        }
        let time = dateService.currentAdjustedUnixTimeStamp
        return ReadEvent(time: time,
                         userId: userId,
                         lastReadMessageTimestamp: lastReadMessageTimestamp)
    }

    func createDeliveryConfirmation(deliveredMessageId: String, userIdInMessage: String) throws -> DeliveryConfirmationEvent {
        guard let senderId = storage.userID else {
            throw EventFactoryError.cannotCreateEvent
        }
        let time = dateService.currentAdjustedUnixTimeStamp
        return DeliveryConfirmationEvent(time: time,
                                         senderId: senderId,
                                         deliveredMessageId: deliveredMessageId,
                                         userId: userIdInMessage)
    }
}
