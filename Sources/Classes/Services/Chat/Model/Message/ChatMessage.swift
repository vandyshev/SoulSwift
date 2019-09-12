import UIKit

/// Chat message
public struct ChatMessage: Equatable {

    /// `id`  - message unique identifier
    let messageId: String

    /// `u`   - message creator identifer
    let userId: String

    /// `t`   - unix timestamp
    let timestamp: UnixTimeStamp

    /// `m`   - message content
    let text: String

    /// `p`   - photo id
    let photoId: String?

    /// `pa`  - album name
    let albumName: String?

    /// `lat` - latitude
    let latitude: Double?

    /// `lng` - longitude
    let longitude: Double?

    /// `s` - system data
    let systemData: SystemDataRepresentation?
}

extension ChatMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case messageId  = "id"
        case userId     = "u"
        case timestamp  = "t"
        case text       = "m"
        case photoId    = "p"
        case albumName  = "pa"
        case latitude   = "lat"
        case longitude  = "lng"
        case systemData = "s"
    }
}

extension ChatMessage {
    var isPhotoMessage: Bool {
        return photoId != nil && albumName != nil
    }

    var isLocationMessage: Bool {
        return latitude != nil && longitude != nil
    }

    var isSystemMessage: Bool {
        return systemData != nil
    }

    var isTextMessage: Bool {
        return !isSystemMessage && !isPhotoMessage && !isLocationMessage
    }

    var content: MessageContent {
        if let lat = latitude, let lng = longitude {
            return .location(latitude: lat, longitude: lng)
        } else if let photoId = photoId, let albumName = albumName {
            return .photo(photoId: photoId, albumName: albumName)
        } else if let systemData = systemData {
            return .system(data: systemData)
        } else if !text.isEmpty {
            return .text(text)
        } else {
            return .unknown
        }
    }
}
