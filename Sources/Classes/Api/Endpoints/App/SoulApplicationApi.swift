import Foundation
import Moya

public enum SoulApplicationApi {
    case features(anonymousId: String?)
}

extension SoulApplicationApi: TargetType {
    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL)! }

    public var path: String {
        switch self {
        case .features:
            return "/application/features"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .features:
            return .get
        }
    }
    public var task: Task {
        switch self {
        case .features(let anonymousId):
            var parameters: [String: Any] = [:]
            parameters["v"] = "1.0.1"
            parameters["apiKey"] = SoulSwiftClient.shared.soulConfiguration.apiKey
            parameters["anonymousUser"] = anonymousId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    public var sampleData: Data {
        switch self {
        case .features:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }

    public var headers: [String: String]? {
        return [:]
    }
}
