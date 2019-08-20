import Foundation
import Moya

typealias SoulApplicationProvider = MoyaProvider<SoulApplicationApi>

public enum SoulApplicationApi {
    case features
    case constants(namespace: String)
}

extension SoulApplicationApi: TargetType, APIVersionTargetType, AnonymousTargetType, AuthorizedTargetType {
    var needsAuth: Bool {
        return true
    }

    var needsAnonymous: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL)! }

    public var path: String {
        switch self {
        case .features:
            return "/application/features"
        case .constants(let namespace):
            return "/application/constants/\(namespace)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        return .requestPlain
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return [:]
    }
}
