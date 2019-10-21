import UIKit
import Moya

/// Loads Chat History
protocol ChatHistoryService: AnyObject {
    func loadHistory(channel: String,
                     historyConfig: ChatHistoryConfig,
                     completion: @escaping (Result<[ChatHistoryObject], ApiError>) -> Void)
}

private enum Constants {
    static let chatHsitoryMappingError = "Can't decode history"
}

final class ChatHistoryServiceImpl: ChatHistoryService {

    private let authHelper: AuthHelper
    private let urlFactory: ChatApiURLFactory
    private let errorService: InternalErrorService
    private let provider: MoyaProvider<ChatApi>
    private let decoder: JSONDecoder
    private let decoderWithoutMilliseconds: JSONDecoder

    init(authHelper: AuthHelper,
         urlFactory: ChatApiURLFactory,
         errorService: InternalErrorService) {
        self.authHelper   = authHelper
        self.urlFactory   = urlFactory
        self.errorService = errorService
        self.provider     = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        self.decoder      = ChatHistoryServiceImpl.createJSONDecoder()

        let formatterWithoutMilliseconds = DateFormatter.iso8601WithoutMilliseconds
        self.decoderWithoutMilliseconds = ChatHistoryServiceImpl
            .createJSONDecoder(formatterWithoutMilliseconds)
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
                    let history = try stelf.decodeHistory(value.data)
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

    private func decodeHistory(_ data: Data) throws -> [ChatHistoryObject] {
        if let history = try? decoder.decode([ChatHistoryObject].self, from: data) {
            return history
        } else {
            return try decoderWithoutMilliseconds.decode([ChatHistoryObject].self,
                                                         from: data)
        }
    }

    private static func createJSONDecoder(_ formatter: DateFormatter
                                            = DateFormatter.iso8601Full) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
