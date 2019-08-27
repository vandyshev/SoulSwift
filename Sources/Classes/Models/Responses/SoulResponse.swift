public struct SoulResponse: Decodable {
    let authorization: Authorization
    let additionalInfo: AdditionalInfo
    let me: MyUser
    let chats: [Chat]
    let chat: Chat
    let events: [Event]
    let currentKing: User
    let bundles: [SoulBundle]
    let items: [InventoryItem]
    let album: Album
    let albums: [Album]
    let photo: Photo
    let photos: [Photo]
    let user: User
    let users: [User]
}
