import UIKit
import Moya

/// Loads Chat History
public protocol ChatHistoryService: AnyObject {
    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void)
}

private enum Constants {
    static let chatHsitoryMappingError = "Can't decode history"
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
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void) {
        let chatApi = ChatApi(chatHistoryConfig: historyConfig,
                              channel: channel,
                              authHelper: authHelper,
                              urlGenerator: urlGenerator)
        provider.request(chatApi) { result in
            switch result {
            case .success(let value):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                do {
                    let history = try decoder.decode([ChatHistoryObject].self, from: value.data)
                    completion(.success(history))
                } catch {
                    let decodableError: ApiError
                        = .mappingError(description: Constants.chatHsitoryMappingError)
                    completion(.failure(decodableError))
                }
            case .failure(let error):
                let apiError = ApiError(moyaError: error)
                completion(.failure(apiError))
            }
        }
    }
}
