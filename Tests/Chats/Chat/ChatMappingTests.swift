import XCTest
import Foundation
@testable import SoulSwift

class ChatMappingTests: XCTestCase {

    let userIdentifier = "userIdentifier"

    var messagesFactory: MessagesFactory!
    var storage: Storage!
    var eventFactory: EventFactory!
    var dateService: DateService!

    override func setUp() {

        storage = FakeStorage(userID: userIdentifier, sessionToken: "token", serverTimeDelta: 0.1)
        dateService = DateServiceMock(currentAdjustedUnixTimeStamp: 1556020950,
                                      adjustedTimeStampFromDate: 1556020952)
        messagesFactory = MessagesFactoryImpl(storage: storage,
                                              dateService: dateService)
        eventFactory = EventFactoryImpl(storage: storage,
                                        dateService: dateService)
    }

    override func tearDown() {
        messagesFactory = nil
        eventFactory = nil
        dateService = nil
        storage = nil
    }

    func testTextMessage() {
        let messageText = "text"
        let content: MessageContent = .text(messageText)
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageId: nil, messageContnet: content)
        } catch {
            fatalError()
        }
        XCTAssertEqual(message.text, messageText)
        XCTAssertEqual(message.timestamp, dateService.currentAdjustedUnixTimeStamp)
        XCTAssertEqual(message.userId, storage.userID)
        XCTAssertNil(message.photoId)
        XCTAssertNil(message.albumName)
        XCTAssertNil(message.latitude)
        XCTAssertNil(message.longitude)
    }

    func testPhotoMessage() {
        let photoId = "photoId"
        let albumId = "albumId"
        let content: MessageContent = .photo(photoId: photoId, albumName: albumId)
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageId: nil, messageContnet: content)
        } catch {
            fatalError()
        }
        XCTAssertEqual(message.text, "")
        XCTAssertEqual(message.timestamp, dateService.currentAdjustedUnixTimeStamp)
        XCTAssertEqual(message.userId, storage.userID)
        XCTAssertEqual(message.photoId, photoId)
        XCTAssertEqual(message.albumName, albumId)
        XCTAssertNil(message.latitude)
        XCTAssertNil(message.longitude)
    }

    func testGeoMessage() {
        let lat: Double = -55
        let lng: Double = 66

        let content: MessageContent = .location(latitude: lat, longitude: lng)
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageId: nil, messageContnet: content)
        } catch {
            fatalError()
        }
        XCTAssertEqual(message.text, "")
        XCTAssertEqual(message.timestamp, dateService.currentAdjustedUnixTimeStamp)
        XCTAssertEqual(message.userId, storage.userID)
        XCTAssertNil(message.photoId)
        XCTAssertNil(message.albumName)
        XCTAssertEqual(message.latitude, lat)
        XCTAssertEqual(message.longitude, lng)
    }

    func testMessageEncoding() {
        let messageText = "text"
        let content: MessageContent = .text(messageText)
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageId: nil, messageContnet: content)
        } catch {
            fatalError()
        }
        guard let jsonString = message.asString else {
            fatalError()
        }
        XCTAssertTrue(jsonString.contains("\"m\":\"text\""))
        XCTAssertTrue(jsonString.contains("\"u\":\"userIdentifier\""))
    }

    func testMessageAcknowledgmentEventMapping() {
        let messageAcknowledgmentEvent = MessageAcknowledgmentEvent(time: 10,
                                                                    messageId: "messageID",
                                                                    userId: "userID")
        guard let data = try? JSONEncoder().encode(messageAcknowledgmentEvent) else {
            fatalError()
        }

        guard let eventType = try? JSONDecoder().decode(EventType.self, from: data) else {
            fatalError()
        }

        guard case .messageAcknowledgment(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(messageAcknowledgmentEvent, event)
    }

    func testHistorySyncEventMapping() {
        let content: MessageContent = .text("message text")
        let message: ChatMessage
        do {
            message = try messagesFactory.createMessage(messageId: nil, messageContnet: content)
        } catch {
            fatalError()
        }
        let historySyncEvent = HistorySyncEvent(time: 10,
                                                userId: "userID",
                                                deviceId: "deviceID",
                                                message: message)
        guard let data = try? JSONEncoder().encode(historySyncEvent) else {
            fatalError()
        }
        guard let eventType = try? JSONDecoder().decode(EventType.self, from: data) else {
            fatalError()
        }

        guard case .historySync(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(historySyncEvent, event)
        XCTAssertEqual(event.message, message)
    }

    func testReadEventMapping() {
        let readEvent = ReadEvent(time: 19, userId: "userId", lastReadMessageTimestamp: 10)
        guard let data = try? JSONEncoder().encode(readEvent) else {
            fatalError()
        }
        guard let eventType = try? JSONDecoder().decode(EventType.self, from: data) else {
            fatalError()
        }

        guard case .readEvent(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(readEvent, event)
    }

    func testDeliveryConfirmationEventMapping() {
        let deliveryEvent = DeliveryConfirmationEvent(time: 10,
                                                      senderId: "userIdWhoSent",
                                                      deliveredMessageId: "deliveredMessageId",
                                                      userId: "userId")

        guard let data = try? JSONEncoder().encode(deliveryEvent) else {
            fatalError()
        }
        guard let eventType = try? JSONDecoder().decode(EventType.self, from: data) else {
            fatalError()
        }

        guard case .deliveryConfirmation(let event) = eventType else {
            fatalError()
        }
        XCTAssertEqual(deliveryEvent, event)
    }

    func testMessageFailedEventMapping() {
        let failedEvent = MessageFailedEvent(time: 10,
                                             messageId: "messageId",
                                             userId: "userId",
                                             error: "error")

        guard let data = try? JSONEncoder().encode(failedEvent) else {
            fatalError()
        }
        guard let eventType = try? JSONDecoder().decode(EventType.self, from: data) else {
            fatalError()
        }

        guard case .messageFailed(let event) = eventType else {
            fatalError()
        }
        XCTAssertEqual(failedEvent, event)
    }

    func testMessageAcknowledgmentEventMappingFromString() {
        let payloadText = """
        {
         "channel": "chat.ec8f9754f943e33c5c04bc8c3e874bf61862f5a8",
         "event": {
                    "t": 1556020950.193132,
                    "a": {
                            "id": "59D72530-E8A5-47B7-9EEE-E5CA65AEAF1B",
                            "u": "5cac47e17981217e4f21745e"
                         }
                  }
        }
        """
        guard let data = payloadText.data(using: .utf8, allowLossyConversion: false) else {
            fatalError()
        }
        guard let payload = try? JSONDecoder().decode(ChatPayload.self, from: data) else {
            fatalError()
        }
        guard case .event(let event) = payload else {
            fatalError()
        }
        XCTAssertEqual("chat.ec8f9754f943e33c5c04bc8c3e874bf61862f5a8", event.channel)
        guard case .messageAcknowledgment(let ack) = event.event else {
            fatalError()
        }
        XCTAssertEqual(ack.messageId, "59D72530-E8A5-47B7-9EEE-E5CA65AEAF1B")
        XCTAssertEqual(ack.time, 1556020950.193132)
    }

    func testReadEventCreation() {
        let lastReadMessageTimestamp: UnixTimeStamp = 1556000050
        guard let event = try? eventFactory.createReadEvent(lastReadMessageTimestamp: lastReadMessageTimestamp) else {
            fatalError()
        }
        XCTAssertEqual(event.lastReadMessageTimestamp, lastReadMessageTimestamp)
        XCTAssertEqual(event.time, dateService.currentAdjustedUnixTimeStamp)
        XCTAssertEqual(event.userId, storage.userID)
    }

    func testDeliveryConfirmationEventCreation() {
        let deliveredMessageId = "deliveredMessageId"
        let userIdInMessage = "userIdInMessage"

        guard let event = try? eventFactory.createDeliveryConfirmation(deliveredMessageId: deliveredMessageId,
                                                                       userIdInMessage: userIdInMessage) else {
            fatalError()
        }
        XCTAssertEqual(event.deliveredMessageId, deliveredMessageId)
        XCTAssertEqual(event.time, dateService.currentAdjustedUnixTimeStamp)
        XCTAssertEqual(event.userId, userIdInMessage)
        XCTAssertEqual(event.senderId, storage.userID)
    }
}
