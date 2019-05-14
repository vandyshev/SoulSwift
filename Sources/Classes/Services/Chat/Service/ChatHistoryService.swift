import UIKit
import Moya

/// Loads Chat History
public protocol ChatHistoryService: AnyObject {
    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], Error>) -> Void)
}

final class ChatHistoryServiceImpl: ChatHistoryService {

    let authHelper: AuthHelper
    let urlGenerator: ChatApiURLGenerator
    let provider: MoyaProvider<ChatApi>

    init(authHelper: AuthHelper, urlGenerator: ChatApiURLGenerator) {
        self.authHelper   = authHelper
        self.urlGenerator = urlGenerator
        self.provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    }

    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], Error>) -> Void) {
        let chatApi = ChatApi(chatHistoryConfig: historyConfig,
                              channel: channel,
                              authHelper: authHelper,
                              urlGenerator: urlGenerator)
        provider.request(chatApi) { result in
            switch result {
            case .success(let value):
                let history = try? JSONDecoder().decode([ChatHistoryObject].self, from: value.data)
                completion(.success(history ?? [])) // TODO: redo
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
