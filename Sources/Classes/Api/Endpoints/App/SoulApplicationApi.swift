import Foundation
import Moya

typealias SoulApplicationProvider = MoyaProvider<SoulApplicationApi>

public enum SoulApplicationApi {
    case features
}

extension SoulApplicationApi: TargetType, APIVersionTargetType, AnonymousTargetType {
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
        case .features:
            return .requestPlain
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
