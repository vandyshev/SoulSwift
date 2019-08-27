public protocol ChatsServiceProtocol {
    // TODO: Узнать у Soul, зачем тут по документации передавать myStatus
    func chats(offset: Int?, limit: Int?, showExpired: Bool?, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void)
    func getChat(withChatId chatId: String, completion: @escaping (Result<Chat, SoulSwiftError>) -> Void)
    func editChat(withChatId chatId: String, myStatus: String, completion: @escaping (Result<Chat, SoulSwiftError>) -> Void)
}

public extension ChatsServiceProtocol {
    func chats(offset: Int? = 0, limit: Int? = 20, showExpired: Bool? = true, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void) {
        chats(offset: offset, limit: limit, showExpired: showExpired, completion: completion)
    }
}

final class ChatsService: ChatsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func chats(offset: Int?, limit: Int?, showExpired: Bool?, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void) {
        let queryParameters: [String: Any?] = [
            "offset": offset,
            "limit": limit,
            "showExpired": showExpired
        ]
        let request = SoulRequest(
            soulEndpoint: SoulChatsEndpoint.chats,
            queryParameters: queryParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.chats })
        }
    }

    func getChat(withChatId chatId: String, completion: @escaping (Result<Chat, SoulSwiftError>) -> Void) {
        let queryParameters = [
            "chatId": chatId
        ]
        let request = SoulRequest(
            soulEndpoint: SoulChatsEndpoint.chatId(chatId: chatId),
            queryParameters: queryParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.chat })
        }
    }

    func editChat(withChatId chatId: String, myStatus: String, completion: @escaping (Result<Chat, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulChatsEndpoint.chatId(chatId: chatId),
            queryParameters: ["chatId": chatId],
            bodyParameters: ["myStatus": myStatus],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.chat })
        }
    }
}
