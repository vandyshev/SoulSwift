public protocol SoulChatsServiceProtocol {
    // TODO: Узнать у Soul, зачем тут по документации передавать myStatus
    func chats(offset: Int?, limit: Int?, showExpired: Bool?, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void)
    func getChat(withChatId chatId: String, completion: @escaping SoulResult<Chat>.Completion)
    func editChat(withChatId chatId: String, myStatus: String, completion: @escaping SoulResult<Chat>.Completion)
}

public extension SoulChatsServiceProtocol {
    func chats(offset: Int? = 0, limit: Int? = 20, showExpired: Bool? = true, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void) {
        chats(offset: offset, limit: limit, showExpired: showExpired, completion: completion)
    }
}

final class SoulChatsService: SoulChatsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func chats(offset: Int?, limit: Int?, showExpired: Bool?, completion: @escaping (Result<[Chat], SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            soulEndpoint: SoulChatsEndpoint.chats,
            needAuthorization: true
        )
        request.setQueryParameters(["offset": offset,
                                    "limit": limit,
                                    "showExpired": showExpired])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.chats })
        }
    }

    func getChat(withChatId chatId: String, completion: @escaping SoulResult<Chat>.Completion) {
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

    func editChat(withChatId chatId: String, myStatus: String, completion: @escaping SoulResult<Chat>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulChatsEndpoint.chatId(chatId: chatId),
            needAuthorization: true
        )
        request.setQueryParameters(["chatId": chatId])
        request.setBodyParameters(["myStatus": myStatus])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.chat })
        }
    }
}
