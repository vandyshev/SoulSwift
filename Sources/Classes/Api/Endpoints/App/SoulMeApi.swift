import Foundation
import Moya

public enum SoulMeApi {
    // swiftlint:disable identifier_name
    case me(Moya.Method)
}

extension SoulMeApi: AuthorizedTargetType {

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .me:
            return "/me"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .me(let method):
            return method
        }
    }
    public var task: Task {
        switch self {
        case .me(let method):
            switch method {
            case .get: return .requestPlain
            case .patch: return .requestPlain
            case .delete: return .requestPlain
            default:
                var parameters: [String: Any] = [:]
                parameters["v"] = "1.0.1"
                parameters["apiKey"] = SoulSwiftClient.shared.soulConfiguration!.apiKey
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            }

        }
    }
    public var sampleData: Data {
        switch self {
        case .me:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        return [:]
    }
    var needsAuth: Bool {
        switch self {
        default:
            return true
        }
    }
}
