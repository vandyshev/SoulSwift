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

    private let authHelper: AuthHelper
    private let urlGenerator: ChatApiURLGenerator
    private let errorService: InternalErrorService
    private let provider: MoyaProvider<ChatApi>
    private let decoder: JSONDecoder

    init(authHelper: AuthHelper,
         urlGenerator: ChatApiURLGenerator,
         errorService: InternalErrorService) {
        self.authHelper   = authHelper
        self.urlGenerator = urlGenerator
        self.errorService = errorService
        self.provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        self.decoder = decoder
    }

    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void) {
        let chatApi = ChatApi(chatHistoryConfig: historyConfig,
                              channel: channel,
                              authHelper: authHelper,
                              urlGenerator: urlGenerator)
        provider.request(chatApi) { [weak self] result in
            guard let stelf = self else { return }
            switch result {
            case .success(let value):
                do {
                    let history = try stelf.decoder.decode([ChatHistoryObject].self, from: value.data)
                    completion(.success(history))
                } catch {
                    let decodableError: ApiError
                        = .mappingError(description: Constants.chatHsitoryMappingError)
                    completion(.failure(decodableError))
                }
            case .failure(let error):
                let apiError = ApiError(moyaError: error)
                self?.errorService.handleError(apiError)
                completion(.failure(apiError))
            }
        }
    }
}
