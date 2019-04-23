//
//  ChatMapping.swift
//  SoulSwift_Tests
//
//  Created by Andrey Mikhaylov on 19/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import Foundation
@testable import SoulSwift

class ChatMapping: XCTestCase {

    let userIdentifier = "userIdentifier"

    var messageGenerator: MessagesGenerator!

    override func setUp() {

        let storage = FakeStorage(userID: userIdentifier, sessionToken: "token", serverTimeDelta: 0.1)
        self.messageGenerator = MessagesGeneratorImpl(storage: storage)
    }

    override func tearDown() {
        self.messageGenerator = nil
    }

    func testTextMessage() {
        let messageText = "text"
        guard let message = messageGenerator.createTextMessage(messageText) else {
            fatalError()
        }
        XCTAssertEqual(message.text, messageText)
        XCTAssertNil(message.photoId)
        XCTAssertNil(message.albumName)
        XCTAssertNil(message.latitude)
        XCTAssertNil(message.longitude)
    }

    func testPhotoMessage() {
        let photoId = "photoId"
        let albumId = "albumId"
        guard let message = messageGenerator.createPhotoMessage(photoId: photoId,
                                                                albumName: albumId) else {
            fatalError()
        }
        XCTAssertEqual(message.text, "")
        XCTAssertEqual(message.photoId, photoId)
        XCTAssertEqual(message.albumName, albumId)
        XCTAssertNil(message.latitude)
        XCTAssertNil(message.longitude)
    }
    
    func testGeoMessage() {
        let lat: Double = -55
        let lng: Double = 66
        guard let message = messageGenerator.createGeoMessage(lat: lat, lng: lng) else {
            fatalError()
        }
        XCTAssertEqual(message.text, "")
        XCTAssertNil(message.photoId)
        XCTAssertNil(message.albumName)
        XCTAssertEqual(message.latitude, lat)
        XCTAssertEqual(message.longitude, lng)
    }
    
    func testMessageEncoding() {
        let messageText = "text"
        guard let message = messageGenerator.createTextMessage(messageText) else {
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
        let data = try! JSONEncoder().encode(messageAcknowledgmentEvent)

        let eventType = try! JSONDecoder().decode(EventType.self, from: data)

        guard case .messageAcknowledgment(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(messageAcknowledgmentEvent, event)
    }
    
    func testHistorySyncEventMapping() {
        guard let message = messageGenerator.createTextMessage("message text") else {
            fatalError()
        }

        let historySyncEvent = HistorySyncEvent(time: 10,
                                                userId: "userID",
                                                deviceId: "deviceID",
                                                message: message)
        let data = try! JSONEncoder().encode(historySyncEvent)
        let eventType = try! JSONDecoder().decode(EventType.self, from: data)

        guard case .historySync(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(historySyncEvent, event)
        XCTAssertEqual(event.message, message)
    }

    func testReadEventMapping() {
        let readEvent = ReadEvent(time: 19, userId: "userId", lastReadMessageTimestamp: 10)
        let data = try! JSONEncoder().encode(readEvent)
        let eventType = try! JSONDecoder().decode(EventType.self, from: data)

        guard case .readEvent(let event) = eventType else {
            fatalError()
        }

        XCTAssertEqual(readEvent, event)
    }
    
    func testDeliveryConfirmationEventMapping() {
        let deliveryEvent = DeliveryConfirmationEvent(time: 10,
                                                      userIdWhoSent: "userIdWhoSent",
                                                      deliveredMessageId: "deliveredMessageId",
                                                      userId: "userId")

        let data = try! JSONEncoder().encode(deliveryEvent)
        let eventType = try! JSONDecoder().decode(EventType.self, from: data)

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

        let data = try! JSONEncoder().encode(failedEvent)
        let eventType = try! JSONDecoder().decode(EventType.self, from: data)

        guard case .messageFailed(let event) = eventType else {
            fatalError()
        }
        XCTAssertEqual(failedEvent, event)
    }
}
