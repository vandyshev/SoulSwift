import UIKit

protocol MessagesFactoryProtocol {
    func createMessage(_ messageContnet: MessageContent) throws -> ChatMessage
}

enum MessagesFactoryError: Error {
    case cannotCreateMessage
}

extension MessagesFactoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotCreateMessage:
            return "Cannot create message"
        }
    }
}

final class MessagesFactory: MessagesFactoryProtocol {

    private struct BaseMessageData {
        let messageId: String
        let userId: String
        let timeStamp: UnixTimeStamp
    }

    private let storage: Storage
    private let dateService: DateServiceProtocol

    init(storage: Storage, dateService: DateServiceProtocol) {
        self.storage = storage
        self.dateService = dateService
    }

    func createMessage(_ messageContnet: MessageContent) throws -> ChatMessage {
        switch messageContnet {
        case let .text(text):
            return try createTextMessage(text)
        case let .photo(photoId: photoId, albumName: albumName):
            return try createPhotoMessage(photoId: photoId, albumName: albumName)
        case let .location(latitude: latitude, longitude: longitude):
            return try createGeoMessage(lat: latitude, lng: longitude)
        }
    }

    private func createTextMessage(_ text: String) throws -> ChatMessage {
        let baseMessageData = try getBaseMessageData()
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

    private func createPhotoMessage(photoId: String, albumName: String) throws -> ChatMessage {
        let baseMessageData = try getBaseMessageData()
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

    private func createGeoMessage(lat: Double, lng: Double) throws -> ChatMessage {
        let baseMessageData = try getBaseMessageData()
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

    private func getBaseMessageData() throws -> BaseMessageData {
        let messageId = UUID().uuidString

        let timeStamp = dateService.currentAdjustedUnixTimeStamp
        guard let userId = storage.userID else {
            throw MessagesFactoryError.cannotCreateMessage
        }
        return BaseMessageData(messageId: messageId,
                               userId: userId,
                               timeStamp: timeStamp)
    }
}
