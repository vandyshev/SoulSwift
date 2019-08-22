enum SoulChatsEndpoint {
    case chats
    case chatId(chatId: String)
}

extension SoulChatsEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .chats:
            return "/chats"
        case .chatId(let chatId):
            return "/chats/\(chatId)"
        }
    }
}
