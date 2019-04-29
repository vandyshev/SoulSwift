import Foundation
import Moya

public struct ChatHistoryConfig {
    let limit: Int
    let offset: Int
    let beforeTimestamp: UnixTimeStamp?
    let afterTimestamp: UnixTimeStamp?
    let beforeIdentifier: String?
    let afterIdentifer: String?
    let beforeMessageIdentifier: String?
    let afterMessageIdentifer: String?
}

extension ChatHistoryConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case beforeTimestamp         = "before"
        case afterTimestamp          = "after"
        case beforeIdentifier        = "before_id"
        case afterIdentifer          = "after_id"
        case beforeMessageIdentifier = "before_message_id"
        case afterMessageIdentifer   = "after_message_id"
    }
}

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
