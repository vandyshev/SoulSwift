import Foundation
import Moya

typealias SoulAuthProvider = MoyaProvider<SoulAuthApi>

enum SoulAuthApi {
    case passwordRegister(parameters: PasswordRegisterRequestParameters)
    case passwordLogin(parameters: PasswordLoginRequestParameters)
    case phoneRequest(parameters: PhoneRequestParameters)
    case phoneVerify(parameters: PhoneVerifyRequestParameters)
    case phoneLogin(parameters: PhoneLoginRequestParameters)
    case emailcodeRequest(parameters: EmailCodeRequestParameters)
    case emailcodeVerify(parameters: EmailCodeVerifyRequestParameters)
    case emailcodeExtend(parameters: EmailCodeExtendRequestParameters)
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
        return false
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
        switch self {
        case .passwordRegister(let parameters):
            return .requestJSONEncodable(parameters)
        case .passwordLogin(let parameters):
            return .requestJSONEncodable(parameters)
        case .phoneRequest(let parameters):
            return .requestJSONEncodable(parameters)
        case .phoneVerify(let parameters):
            return .requestJSONEncodable(parameters)
        case .phoneLogin(let parameters):
            return .requestJSONEncodable(parameters)
        case .emailcodeRequest(let parameters):
            return .requestJSONEncodable(parameters)
        case .emailcodeVerify(let parameters):
            return .requestJSONEncodable(parameters)
        case .emailcodeExtend(let parameters):
            return .requestJSONEncodable(parameters)
        default:
            return .requestPlain
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return [:]
    }
}
