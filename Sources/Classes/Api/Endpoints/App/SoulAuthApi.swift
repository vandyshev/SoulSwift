import Foundation
import Moya

typealias SoulAuthProvider = MoyaProvider<SoulAuthApi>

public enum SoulAuthApi {
    case passwordRegister
}

extension SoulAuthApi: TargetType, APIVersionTargetType, AnonymousTargetType {
    var needsAnonymous: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL)! }

    public var path: String {
        switch self {
        case .passwordRegister:
            return "/auth/password/register"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .passwordRegister:
            return .post
        }
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
