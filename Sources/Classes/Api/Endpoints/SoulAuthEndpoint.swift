enum SoulAuthEndpoint {
    case passwordRegister
    case passwordLogin
    case phoneRequest
    case phoneVerify
    case phoneLogin
    case emailCodeRequest
    case emailCodeVerify
    case emailCodeExtend
    case logout
}

extension SoulAuthEndpoint: SoulEndpoint {
    var path: String {
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
        case .emailCodeRequest:
            return "/auth/emailcode/request"
        case .emailCodeVerify:
            return "/auth/emailcode/verify"
        case .emailCodeExtend:
            return "/auth/emailcode/extend"
        case .logout:
            return "/auth/logout"
        }
    }
}
