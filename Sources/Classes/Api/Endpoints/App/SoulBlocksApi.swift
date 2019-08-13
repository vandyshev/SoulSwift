import Foundation
import Moya

typealias SoulBlocksProvider = MoyaProvider<SoulBlocksApi>

public enum SoulBlocksApi {
    case soulKoth
}

extension SoulBlocksApi: TargetType, APIVersionTargetType, AuthorizedTargetType {
    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL)! }

    public var path: String {
        switch self {
        case .soulKoth:
            return "/blocks/soul/koth/"
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
