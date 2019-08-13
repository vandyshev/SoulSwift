import Foundation
import Moya

typealias SoulUsersProvider = MoyaProvider<SoulUsersApi>

public enum SoulUsersApi {
    case recommendationsList
}

extension SoulUsersApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .recommendationsList:
            return "/users/recommendations/list"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .recommendationsList:
            return .get
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
