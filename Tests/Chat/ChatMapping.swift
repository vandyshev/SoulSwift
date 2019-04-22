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
    
}
