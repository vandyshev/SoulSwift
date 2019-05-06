import Foundation
import Moya

struct ChatApi {
    let chatHistoryConfig: ChatHistoryConfig
    let channel: String
    let authHelper: AuthHelper
    let uriGenerator: ChatClientURIGenerator
}

extension ChatApi: TargetType {
    var baseURL: URL {
        return URL(string: uriGenerator.urlWithApiKey)!
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
        return .requestJSONEncodable(chatHistoryConfig)
    }

    var headers: [String: String]? {
        var result = [String: String]()
        result["Authorization"] = authHelper.authString(withEndpoint: uriGenerator.chatAuthEndpoint,
                                                        method: uriGenerator.chatAuthMethod,
                                                        body: "")
        result["User-Agent"] = authHelper.userAgent
        return result
    }
}
