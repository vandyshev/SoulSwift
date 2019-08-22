// swiftlint:disable function_parameter_count line_length
public protocol AuthServiceProtocol: AnyObject {

    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void)

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void)

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void)
}

final class AuthService: AuthServiceProtocol {

    let soulApiProvider: SoulApiProviderProtocol

    init(soulApiProvider: SoulApiProviderProtocol) {
        self.soulApiProvider = soulApiProvider
    }

    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "login": login,
            "passwd": password,
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "merge": merge,
            "mergePreference": mergePreference
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.passwordRegister,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "login": login,
            "password": password,
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "merge": merge,
            "mergePreference": mergePreference
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.passwordLogin,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "method": method,
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.phoneRequest,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<PhoneRequestResponse, SoulSwiftError>) in
            completion(result)
        }
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "code": code,
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "merge": merge,
            "mergePreference": mergePreference
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.phoneVerify,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "code": code,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "lastSessionToken": lastSessionToken
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.phoneLogin,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "email": email,
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.emailCodeRequest,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<EmailCodeRequestResponse, SoulSwiftError>) in
            completion(result)
        }
    }

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "email": email,
            "code": code,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "merge": merge,
            "mergePreference": mergePreference
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.emailCodeVerify,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<Authorization, SoulSwiftError>) -> Void) {
        let bodyParameters: [String: Any] = [
            "email": email,
            "code": code,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
            "lastSessionToken": lastSessionToken
        ]
        let request = SoulApiRequest(
            httpMethod: .POST,
            soulApiEndpoint: SoulAuthApiEndpoint.emailCodeExtend,
            queryItems: nil,
            bodyParameters: bodyParameters,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<AuthResponse, SoulSwiftError>) in
            completion(result.map { $0.authorization })
        }
    }
}
