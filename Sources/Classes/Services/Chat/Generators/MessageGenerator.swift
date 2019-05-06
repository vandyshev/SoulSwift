import UIKit

protocol MessagesGenerator {
    func createMessage(_ messageToSend: MessageToSend) -> ChatMessage?
    func createTextMessage(_ text: String) -> ChatMessage?
    func createPhotoMessage(photoId: String, albumName: String) -> ChatMessage?
    func createGeoMessage(lat: Double, lng: Double) -> ChatMessage?
}

final class MessagesGeneratorImpl: MessagesGenerator {

    private struct BaseMessageData {
        let messageId: String
        let userId: String
        let timeStamp: UnixTimeStamp
    }

    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func createMessage(_ messageToSend: MessageToSend) -> ChatMessage? {
        switch messageToSend {
        case let .text(text):
            return createTextMessage(text)
        case let .photo(photoId: photoId, albumName: albumName):
            return createPhotoMessage(photoId: photoId, albumName: albumName)
        case let .location(latitude: latitude, longitude: longitude):
            return createGeoMessage(lat: latitude, lng: longitude)
        }
    }

    func createTextMessage(_ text: String) -> ChatMessage? {
        guard let baseMessageData = getBaseMessageData() else { return nil }
        let message = ChatMessage(messageId: baseMessageData.messageId,
                                  userId: baseMessageData.userId,
                                  timestamp: baseMessageData.timeStamp,
                                  text: text,
                                  photoId: nil,
                                  albumName: nil,
                                  latitude: nil,
                                  longitude: nil)
        return message
    }

    func createPhotoMessage(photoId: String, albumName: String) -> ChatMessage? {
        guard let baseMessageData = getBaseMessageData() else { return nil }
        let message = ChatMessage(messageId: baseMessageData.messageId,
                                  userId: baseMessageData.userId,
                                  timestamp: baseMessageData.timeStamp,
                                  text: "",
                                  photoId: photoId,
                                  albumName: albumName,
                                  latitude: nil,
                                  longitude: nil)
        return message
    }

    func createGeoMessage(lat: Double, lng: Double) -> ChatMessage? {
        guard let baseMessageData = getBaseMessageData() else { return nil }
        let message = ChatMessage(messageId: baseMessageData.messageId,
                                  userId: baseMessageData.userId,
                                  timestamp: baseMessageData.timeStamp,
                                  text: "",
                                  photoId: nil,
                                  albumName: nil,
                                  latitude: lat,
                                  longitude: lng)
        return message
    }

    private func getBaseMessageData() -> BaseMessageData? {
        let messageId = UUID().uuidString
        let timeStamp = DateHelper.currentUnixTimestamp
        guard let userId = storage.userID else { return nil }
        return BaseMessageData(messageId: messageId,
                               userId: userId,
                               timeStamp: timeStamp)
    }
}
