import UIKit
import Moya

/// Loads Chat History
protocol ChatHistoryServiceProtocol: AnyObject {
    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void)
}

private enum Constants {
    static let chatHsitoryMappingError = "Can't decode history"
}

final class ChatHistoryService: ChatHistoryServiceProtocol {

    private let authHelper: AuthHelperProtocol
    private let urlFactory: ChatApiURLFactoryProtocol
    private let errorService: InternalErrorService
    private let provider: MoyaProvider<ChatApi>
    private let decoder: JSONDecoder

    init(authHelper: AuthHelperProtocol,
         urlFactory: ChatApiURLFactoryProtocol,
         errorService: InternalErrorService) {
        self.authHelper   = authHelper
        self.urlFactory   = urlFactory
        self.errorService = errorService
        self.provider     = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        self.decoder      = ChatHistoryService.createJSONDecoder()
    }

    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void) {
        let chatApi = ChatApi(chatHistoryConfig: historyConfig,
                              channel: channel,
                              authHelper: authHelper,
                              urlFactory: urlFactory)
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

    private static func createJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }
}
