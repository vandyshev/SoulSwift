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
        guard let encodedData = try? JSONEncoder().encode(chatHistoryConfig) else {
            return .requestPlain
        }
        guard let json = try? JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any] else {
            // appropriate error handling
            return .requestPlain
        }
        print(json)
        return .requestParameters(parameters: json ?? [:], encoding: URLEncoding.queryString)
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
