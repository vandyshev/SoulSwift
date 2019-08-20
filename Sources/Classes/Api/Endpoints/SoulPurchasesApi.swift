import Foundation
import Moya

typealias SoulPurchasesProvider = MoyaProvider<SoulPurchasesApi>

public enum SoulPurchasesApi {
    case orderAppstore
    case all
    case my
    case consume
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
        case .orderAppstore:
            return "/purchases/order/appstore"
        case .all:
            return "/purchases/all"
        case .my:
            return "/purchases/my"
        case .consume:
            return "/purchases/consume"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .orderAppstore, .consume:
            return .post
        case .all, .my:
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
