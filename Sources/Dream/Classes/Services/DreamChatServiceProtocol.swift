protocol DreamChatServiceProtocol: AnyObject {
    func loadHistory(channel: String, historyConfig: ChatHistoryConfig, completion: @escaping (Result<[ChatHistoryObject], SoulSwiftError>) -> Void)
}

final class DreamChatService: DreamChatServiceProtocol {

    let dreamProvider: DreamProviderProtocol

    init(dreamProvider: DreamProviderProtocol) {
        self.dreamProvider = dreamProvider
    }

    func loadHistory(channel: String, historyConfig: ChatHistoryConfig, completion: @escaping (Result<[ChatHistoryObject], SoulSwiftError>) -> Void) {
        let request = DreamRequest(soulEndpoint: DreamChatEndpoint.chatHistory(channel: channel),
                                   body: historyConfig,
                                   needAuthorization: true)
        dreamProvider.request(request, completion: completion)
    }

}
