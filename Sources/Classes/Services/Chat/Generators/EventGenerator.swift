import UIKit

protocol EventGenerator {
    func createReadEvent(lastReadMessageTimestamp: UnixTimeStamp) -> ReadEvent?
    func createDeliveryConfirmation(deliveredMessageId: String, userIdInMessage: String) -> DeliveryConfirmationEvent?
}

final class EventGeneratorImpl: EventGenerator {

    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func createReadEvent(lastReadMessageTimestamp: UnixTimeStamp) -> ReadEvent? {

        guard let userId = storage.userID else {
            return nil
        }
        let time = DateHelper.currentUnixTimestamp
        return ReadEvent(time: time,
                         userId: userId,
                         lastReadMessageTimestamp: lastReadMessageTimestamp)
    }

    func createDeliveryConfirmation(deliveredMessageId: String, userIdInMessage: String) -> DeliveryConfirmationEvent? {
        guard let userIdWhoSentEvent = storage.userID else {
            return nil
        }
        let time = DateHelper.currentUnixTimestamp
        return DeliveryConfirmationEvent(time: time,
                                         userIdWhoSentEvent: userIdWhoSentEvent,
                                         deliveredMessageId: deliveredMessageId,
                                         userId: userIdInMessage)
    }
}
