// swiftlint:disable function_parameter_count line_length
public protocol AuthServiceProtocol {

    func passwordRegister(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)

    func passwordLogin(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void)

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void)

    func emailCodeVerify(email: String, code: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class AuthService: AuthServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func passwordRegister(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        passwordRegister(login: login, password: password, merge: nil, mergePreference: nil, completion: completion)
    }

    func passwordLogin(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        passwordLogin(login: login, password: password, merge: nil, mergePreference: nil, completion: completion)
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        phoneVerify(phoneNumber: phoneNumber, code: code, method: method, merge: nil, mergePreference: nil, completion: completion)
    }

    func emailCodeVerify(email: String, code: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        emailCodeVerify(email: email, code: code, merge: nil, mergePreference: nil, completion: completion)
    }

    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.passwordRegister
        )
        request.setBodyParameters([ "login": login,
                                    "passwd": password,
                                    "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                    "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                    "merge": merge,
                                    "mergePreference": mergePreference ])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.passwordLogin
        )
        request.setBodyParameters(["login": login,
                                   "password": password,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneRequest
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "method": method,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey])
        soulProvider.request(request) { (result: Result<PhoneRequestResponse, SoulSwiftError>) in
            completion(result)
        }
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneVerify
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "code": code,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneLogin
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "lastSessionToken": lastSessionToken])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeRequest
        )
        request.setBodyParameters(["email": email,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey])
        soulProvider.request(request) { (result: Result<EmailCodeRequestResponse, SoulSwiftError>) in
            completion(result)
        }
    }

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeVerify,
            queryParameters: nil,
            needAuthorization: false
        )
        request.setBodyParameters(["email": email,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeExtend
        )
        request.setBodyParameters(["email": email,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "lastSessionToken": lastSessionToken])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }
}
