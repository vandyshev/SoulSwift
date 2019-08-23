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
}
