import Foundation
import Moya

struct ChatApi {
    let chatHistoryConfig: ChatHistoryConfig
    let channel: String
    let authHelper: AuthHelper
    let urlFactory: ChatApiURLFactory
}

extension ChatApi: TargetType {
    var baseURL: URL {
        return URL(string: urlFactory.httpUrlWithApiKey)!
    }

    var path: String {
        return "chat/history/\(channel)"
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        let parameters = chatHistoryConfig.asDictionary ?? [:]
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        var result = [String: String]()
        let authConfig = AuthConfig(endpoint: urlFactory.chatAuthEndpoint,
                                    method: urlFactory.chatAuthMethod,
                                    body: "")
        result["Authorization"] = authHelper.authString(withAuthConfig: authConfig)
        result["User-Agent"] = authHelper.userAgent
        return result
    }
}
