enum DreamChatEndpoint {
    case chatHistory(channel: String)
}

extension DreamChatEndpoint: DreamEndpoint {
    var path: String {
        switch self {
        case .chatHistory(let channel):
            return "chat/history/\(channel)"
        }
    }
}
