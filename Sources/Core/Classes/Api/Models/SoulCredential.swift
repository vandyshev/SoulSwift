struct SoulCredential: Codable {
    let method: AuthMethod
    let authorization: Authorization
    let me: MyUser
}

enum AuthMethod: Codable {
    case password(login: String, password: String)
    case phone(phoneNumber: String, code: String)
    case email(email: String, code: String)

    enum CodingKeys: CodingKey {
        case method
        case login
        case password
        case phoneNumber
        case phoneCode
        case email
        case emailCode
    }

    enum CodingError: Error {
        case credentialCodingError
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .password(let login, let password):
            try container.encode("password", forKey: .method)
            try container.encode(login, forKey: .login)
            try container.encode(password, forKey: .password)
        case .phone(let phoneNumber, let code):
            try container.encode("phone", forKey: .method)
            try container.encode(phoneNumber, forKey: .phoneNumber)
            try container.encode(code, forKey: .phoneCode)
        case .email(let email, let code):
            try container.encode("email", forKey: .method)
            try container.encode(email, forKey: .email)
            try container.encode(code, forKey: .emailCode)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let method = try container.decode(String.self, forKey: .method)
        switch method {
        case "password":
            let login = try container.decode(String.self, forKey: .login)
            let password = try container.decode(String.self, forKey: .password)
            self = .password(login: login, password: password)
        case "phone":
            let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
            let code = try container.decode(String.self, forKey: .phoneCode)
            self = .phone(phoneNumber: phoneNumber, code: code)
        case "email":
            let email = try container.decode(String.self, forKey: .email)
            let code = try container.decode(String.self, forKey: .emailCode)
            self = .email(email: email, code: code)
        default:
            throw CodingError.credentialCodingError
        }
    }
}

extension AuthMethod {
    var account: String {
        switch self {
        case .password(let login, _):
            return login
        case .phone(let phoneNumber, _):
            return phoneNumber
        case .email(let email, _):
            return email
        }
    }
}
