import Foundation
import Moya

typealias SoulMeProvider = MoyaProvider<SoulMeApi>

public enum SoulMeApi {
    case me(Moya.Method)
}

extension SoulMeApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

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
        return .requestPlain
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
}
