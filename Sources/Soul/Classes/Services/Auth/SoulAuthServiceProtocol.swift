// swiftlint:disable function_parameter_count line_length
public protocol SoulAuthServiceProtocol {
    var isAuthorized: Bool { get }
    var account: String? { get }
    var errorCompletion: ((Error) -> Void)? { get set}

    // POST: /auth/password/register
    func passwordRegister(login: String, password: String, completion: @escaping SoulResult<MyUser>.Completion)
    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion)
    // POST: /auth/password/login
    func passwordLogin(login: String, password: String, completion: @escaping SoulResult<MyUser>.Completion)
    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion)

    // POST: /auth/phone/request
    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping SoulResult<PhoneRequestResponse>.Completion)
    // POST: /auth/phone/verify
    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, completion: @escaping SoulResult<MyUser>.Completion)
    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion)

    // POST: /auth/emailcode/request
    func emailCodeRequest(email: String, captchaToken: String?, completion: @escaping SoulResult<EmailCodeRequestResponse>.Completion)
    // POST: /auth/emailcode/verify
    func emailCodeVerify(email: String, code: String, completion: @escaping SoulResult<MyUser>.Completion)
    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion)

    // POST: /auth/apple/verify
    func appleVerify(email: String?, code: String, token: String, userStatus: Int, completion: @escaping SoulResult<MyUser>.Completion)
    func appleVerify(email: String?, code: String, token: String, userStatus: Int, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion)

    // POST: /auth/logout
    func logout(full: Bool?, completion: @escaping SoulResult<Void>.Completion)
}

final class SoulAuthService: SoulAuthServiceProtocol {

    private let soulProvider: SoulProviderProtocol
    private let soulAuthorizationProvider: SoulAuthorizationProviderProtocol

    var isAuthorized: Bool {
        return soulAuthorizationProvider.isAuthorized
    }

    var account: String? {
        return soulAuthorizationProvider.account
    }

    var errorCompletion: ((Error) -> Void)?

    init(soulProvider: SoulProviderProtocol,
         soulAuthorizationProvider: SoulAuthorizationProviderProtocol) {
        self.soulProvider = soulProvider
        self.soulAuthorizationProvider = soulAuthorizationProvider
    }

    func passwordRegister(login: String, password: String, completion: @escaping SoulResult<MyUser>.Completion) {
        passwordRegister(login: login, password: password, merge: nil, mergePreference: nil, completion: completion)
    }

    func passwordLogin(login: String, password: String, completion: @escaping SoulResult<MyUser>.Completion) {
        passwordLogin(login: login, password: password, merge: nil, mergePreference: nil, completion: completion)
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, completion: @escaping SoulResult<MyUser>.Completion) {
        phoneVerify(phoneNumber: phoneNumber, code: code, method: method, merge: nil, mergePreference: nil, completion: completion)
    }

    func emailCodeVerify(email: String, code: String, completion: @escaping SoulResult<MyUser>.Completion) {
        emailCodeVerify(email: email, code: code, merge: nil, mergePreference: nil, completion: completion)
    }

    func appleVerify(email: String?, code: String, token: String, userStatus: Int, completion: @escaping SoulResult<MyUser>.Completion) {
        appleVerify(email: email, code: code, token: token, userStatus: userStatus, merge: nil, mergePreference: nil, completion: completion)
    }

    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion) {
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
                    with: self?.soulAuthorizationProvider.saveAuthorization
                )
            )
        }
    }

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion) {
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
                    with: self?.soulAuthorizationProvider.saveAuthorization
                )
            )
        }
    }

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping SoulResult<PhoneRequestResponse>.Completion) {
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

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion) {
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
                    with: self?.soulAuthorizationProvider.saveAuthorization
                )
            )
        }
    }

    func emailCodeRequest(email: String, captchaToken: String?, completion: @escaping SoulResult<EmailCodeRequestResponse>.Completion) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeRequest
        )
        request.setBodyParameters(["email": email,
                                   "captchaToken": captchaToken,
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

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion) {
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
                    with: self?.soulAuthorizationProvider.saveAuthorization
                )
            )
        }
    }

    func appleVerify(email: String?, code: String, token: String, userStatus: Int, merge: Bool?, mergePreference: MergePreference?, completion: @escaping SoulResult<MyUser>.Completion) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.appleVerify,
            queryParameters: nil,
            needAuthorization: merge ?? false
        )
        request.setBodyParameters(["email": email,
                                   "code": code,
                                   "id_token": token,
                                   "user_status": userStatus,
                                   "apiKey": SoulClient.shared.soulConfiguration.apiKey,
                                   "merge": merge,
                                   "mergePreference": mergePreference])
        soulProvider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .apple(email: email, code: code, token: token),
                    with: self?.soulAuthorizationProvider.saveAuthorization
                )
            )
        }
    }

    func logout(full: Bool?, completion: @escaping SoulResult<Void>.Completion) {
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
