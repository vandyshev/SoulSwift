import Foundation

public typealias UnixTimeStamp = Double

// swiftlint:disable identifier_name
public class SoulResponse: Decodable {
    let features: Features?
    let status: String?
    let providerId: Int?
    let authorization: Authorization?
    let additionalInfo: AdditionalInfo?
    let me: MyUser?
    let chats: [Chat]?
    let chat: Chat?
    let events: [Event]?
    let currentKing: User?
    let album: Album?
    let albums: [Album]?
    let photo: Photo?
    let photos: [Photo]?
    let user: User?
    let users: [User]?
    let request: ContactRequest?
    let _meta: Meta?

        enum CodingKeys: String, CodingKey {
            case features
            case status
            case providerId
            case authorization
            case additionalInfo
            case me
            case chats
            case chat
            case events
            case currentKing
            case album
            case albums
            case photo
            case photos
            case user
            case users
            case request
            case _meta
        }
    
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            features = try container.decode(Features.self, forKey: .features)
            status = nil
            providerId = nil
            authorization = nil
            additionalInfo = nil
            me = nil
            chats = nil
            chat = nil
            events = nil
            currentKing = nil
            album = nil
            albums = nil
            photo = nil
            photos = nil
            user = nil
            users = nil
            request = nil
            _meta = nil
        }
}

