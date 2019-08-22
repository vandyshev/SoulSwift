enum SoulChatsApiEndpoint {
    case chats
    case chatId(chatId: String)
}

extension SoulChatsApiEndpoint: SoulApiEndpoint {
    var path: String {
        switch self {
        case .chats:
            return "/chats"
        case .chatId(let chatId):
            return "/chats/\(chatId)"
        }
    }
}
