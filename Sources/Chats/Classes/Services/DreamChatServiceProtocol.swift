protocol DreamChatServiceProtocol: AnyObject {
    func loadHistory(channel: String, historyConfig: ChatHistoryConfig, completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void)
}

final class DreamChatService: DreamChatServiceProtocol {

//    let dreamProvider: DreamProviderProtocol
//
//    init(dreamProvider: DreamProviderProtocol) {
//        self.dreamProvider = dreamProvider
//    }

    func loadHistory(channel: String, historyConfig: ChatHistoryConfig, completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void) {
        
    }

}

