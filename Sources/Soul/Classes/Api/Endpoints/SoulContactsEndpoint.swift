enum SoulContactsEndpoint {
    case sendContactRequest
    case cancelContactRequest(requestId: String)
    case approveContactRequest(requestId: String)
    case declineContactRequest(requestId: String)
    case editContactName(userId: String)
    case deleteContact(userId: String)
    case lastSentRequest(chatId: String)
}

extension SoulContactsEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .sendContactRequest:
            return "/contacts/requests"
        case .cancelContactRequest(let requestId):
            return "/contacts/\(requestId)/cancel"
        case .approveContactRequest(let requestId):
            return "/contacts/\(requestId)/approve"
        case .declineContactRequest(let requestId):
            return "/contacts/\(requestId)/decline"
        case .editContactName(let userId):
            return "/contacts/\(userId)"
        case .deleteContact(let userId):
            return "/contacts/\(userId)"
        case .lastSentRequest(let chatId):
            return "/contacts/requests/last_sent/\(chatId)"
        }
    }
}
