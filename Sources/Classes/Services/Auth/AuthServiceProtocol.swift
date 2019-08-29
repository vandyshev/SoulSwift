// swiftlint:disable function_parameter_count line_length
public protocol AuthServiceProtocol {
    // POST: /auth/password/register
    func passwordRegister(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/password/login
    func passwordLogin(login: String, password: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/phone/request
    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void)
    // POST: /auth/phone/verify
    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/phone/login
    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/emailcode/request
    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void)
    // POST: /auth/emailcode/verify
    func emailCodeVerify(email: String, code: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST:/auth/emailcode/extend
    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/logout
    func logout(full: Bool?, completion: @escaping (Result<Void, SoulSwiftError>) -> Void)
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
            soulEndpoint: SoulAuthEndpoint.passwordRegister,
            needAuthorization: merge ?? false
        )
        request.setBodyParameters([ "login": login,
                                    "passwd": password,
                                    "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                    "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                    "merge": merge,
                                    "mergePreference": mergePreference ])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
        }
    }

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.passwordLogin,
            needAuthorization: merge ?? false
        )
        request.setBodyParameters(["login": login,
                                   "password": password,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
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
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map {
                guard let status = $0.status else { return nil }
                guard let providerId = $0.providerId else { return nil }
                guard let additionalInfo = $0.additionalInfo else { return nil }
                return PhoneRequestResponse(status: status, providerId: providerId, additionalInfo: additionalInfo)
            })
        }
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneVerify,
            needAuthorization: merge ?? false
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "code": code,
                                   "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
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
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
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
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map {
                guard let status = $0.status else { return nil }
                guard let providerId = $0.providerId else { return nil }
                guard let additionalInfo = $0.additionalInfo else { return nil }
                return EmailCodeRequestResponse(status: status, providerId: providerId, additionalInfo: additionalInfo)
            })
        }
    }

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeVerify,
            queryParameters: nil,
            needAuthorization: merge ?? false
        )
        request.setBodyParameters(["email": email,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
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
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.authorization, $0.me) }.map(self?.saveAuthorization))
        }
    }

    func logout(full: Bool?, completion: @escaping (Result<Void, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.logout,
            needAuthorization: true
        )
        request.setQueryParameters(["full": full])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    private func saveAuthorization(authorization: Authorization) {
        print(authorization)
    }
}

private extension Result where Success == (Authorization, MyUser), Failure == SoulSwiftError {
    func map(_ saveAuthorization: ((Authorization) -> Void)?) -> Result<MyUser, SoulSwiftError> {
        switch self {
        case .success(let authorization, let me):
            saveAuthorization?(authorization)
            return .success(me)
        case .failure(let error):
            return .failure(error)
        }
    }
}
