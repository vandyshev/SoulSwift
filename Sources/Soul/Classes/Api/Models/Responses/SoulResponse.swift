import Foundation

public typealias UnixTimeStamp = Double

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
    let meta: Meta?

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
        case meta = "_meta"
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        features = try container.decodeIfPresent(Features.self, forKey: .features)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        providerId = try container.decodeIfPresent(Int.self, forKey: .providerId)
        authorization = try container.decodeIfPresent(Authorization.self, forKey: .authorization)
        additionalInfo = try container.decodeIfPresent(AdditionalInfo.self, forKey: .additionalInfo)
        me = try container.decodeIfPresent(MyUser.self, forKey: .me)
        chats = try container.decodeIfPresent([Chat].self, forKey: .chats)
        chat = try container.decodeIfPresent(Chat.self, forKey: .chat)
        events = try container.decodeIfPresent([Event].self, forKey: .events)
        currentKing = try container.decodeIfPresent(User.self, forKey: .currentKing)
        album = try container.decodeIfPresent(Album.self, forKey: .album)
        albums = try container.decodeIfPresent([Album].self, forKey: .albums)
        photo = try container.decodeIfPresent(Photo.self, forKey: .photo)
        photos = try container.decodeIfPresent([Photo].self, forKey: .photos)
        user = try container.decodeIfPresent(User.self, forKey: .user)
        users = try container.decodeIfPresent([User].self, forKey: .users)
        request = try? container.decodeIfPresent(ContactRequest.self, forKey: .request)
        meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
    }
}
