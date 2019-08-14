import Foundation
import Moya

typealias SoulAuthProvider = MoyaProvider<SoulAuthApi>

public enum SoulAuthApi {
    case passwordRegister
    case passwordLogin
    case phoneRequest
    case phoneVerify
    case phoneLogin
    case emailcodeRequest
    case emailcodeVerify
    case emailcodeExtend
    case logout
}

extension SoulAuthApi: TargetType, APIVersionTargetType, AnonymousTargetType, AuthorizedTargetType {
    var needsAuth: Bool {
        switch self {
        case .logout:
            return true
        default:
            return false
        }
    }

    var needsAnonymous: Bool {
        switch self {
        case .logout:
            return false
        default:
            return true
        }
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL)! }

    public var path: String {
        switch self {
        case .passwordRegister:
            return "/auth/password/register"
        case .passwordLogin:
            return "/auth/password/login"
        case .phoneRequest:
            return "/auth/phone/request"
        case .phoneVerify:
            return "/auth/phone/verify"
        case .phoneLogin:
            return "/auth/phone/login"
        case .emailcodeRequest:
            return "/auth/emailcode/request"
        case .emailcodeVerify:
            return "/auth/emailcode/verify"
        case .emailcodeExtend:
            return "/auth/emailcode/extend"
        case .logout:
            return "/auth/logout"
        }
    }

    public var method: Moya.Method {
        return .post
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
