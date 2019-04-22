import UIKit

protocol MessagesGenerator {
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
        let timeStamp = DateHelper.currentUnixTimestamp // todo: check this. move to date service
        guard let userId = storage.userID else { return nil }
        return BaseMessageData(messageId: messageId,
                               userId: userId,
                               timeStamp: timeStamp)
    }
}
