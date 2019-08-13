import Foundation
import Moya

typealias SoulPurchasesProvider = MoyaProvider<SoulPurchasesApi>

public enum SoulPurchasesApi {
    case all
}

extension SoulPurchasesApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .all:
            return "/purchases/all"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .all:
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
