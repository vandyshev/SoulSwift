import Foundation
import Moya

struct ChatApi {
    let chatHistoryConfig: ChatHistoryConfig
    let channel: String
    let authHelper: AuthHelper
    let urlGenerator: ChatApiURLGenerator
}

extension ChatApi: TargetType {
    var baseURL: URL {
        return URL(string: urlGenerator.httpUrlWithApiKey)!
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
        result["Authorization"] = authHelper.authString(withEndpoint: urlGenerator.chatAuthEndpoint,
                                                        method: urlGenerator.chatAuthMethod,
                                                        body: "")
        result["User-Agent"] = authHelper.userAgent
        return result
    }
}
