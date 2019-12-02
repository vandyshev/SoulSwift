import UIKit

/// Chat message
public struct ChatMessage: Equatable {

    /// `id`  - message unique identifier
    public let messageId: String

    /// `u`   - message creator identifer
    public let userId: String

    /// `t`   - unix timestamp
    public let timestamp: UnixTimeStamp

    /// `m`   - message content
    public let text: String

    /// `p`   - photo id
    public let photoId: String?

    /// `pa`  - album name
    public let albumName: String?

    /// `lat` - latitude
    public let latitude: Double?

    /// `lng` - longitude
    public let longitude: Double?

    /// `s` - system data
    public let systemData: SystemDataRepresentation?
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

    public var content: MessageContent {
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
