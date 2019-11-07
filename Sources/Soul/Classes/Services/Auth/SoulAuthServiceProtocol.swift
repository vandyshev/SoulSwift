// swiftlint:disable function_parameter_count line_length
public protocol SoulAuthServiceProtocol {
    var isAuthorized: Bool { get }
    var account: String? { get }

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

    // POST: /auth/emailcode/request
    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void)
    // POST: /auth/emailcode/verify
    func emailCodeVerify(email: String, code: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // POST: /auth/logout
    func logout(full: Bool?, completion: @escaping (Result<Void, SoulSwiftError>) -> Void)
}

final class SoulAuthService: SoulAuthServiceProtocol {

    private let soulProvider: SoulProviderProtocol
    private var storageService: StorageServiceProtocol

    var isAuthorized: Bool {
        return storageService.credential != nil
    }

    var account: String? {
        return storageService.credential?.method.account
    }

    init(soulProvider: SoulProviderProtocol, storageService: StorageServiceProtocol) {
        self.soulProvider = soulProvider
        self.storageService = storageService
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
                                    "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                    "apiKey": SoulClient.shared.soulConfiguration.apiKey,
                                    "merge": merge,
                                    "mergePreference": mergePreference ])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .password(login: login, password: password),
                    with: self?.saveAuthorization
                )
            )
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
                                   "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .password(login: login, password: password),
                    with: self?.saveAuthorization
                )
            )
        }
    }

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneRequest
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "method": method,
                                   "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey])
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
                                   "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .phone(phoneNumber: phoneNumber, code: code),
                    with: self?.saveAuthorization
                )
            )
        }
    }

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeRequest
        )
        request.setBodyParameters(["email": email,
                                   "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey])
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
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .email(email: email, code: code),
                    with: self?.saveAuthorization
                )
            )
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

    private func saveAuthorization(method: AuthMethod, authorization: Authorization, me: MyUser) {
        let credential = SoulCredential(method: method, authorization: authorization, me: me)
        storageService.credential = credential
    }
}

private extension Result where Success == SoulResponse, Failure == SoulSwiftError {

    func afterSaveAuthorization(for method: AuthMethod, with saveClosure: ((AuthMethod, Authorization, MyUser) -> Void)?) -> Result<MyUser, SoulSwiftError> {
        let result = map { ($0.authorization, $0.me) }
        switch result {
        case .success(let authorization, let me):
            saveClosure?(method, authorization, me)
            return .success(me)
        case .failure(let error):
            return .failure(error)
        }
    }
}
