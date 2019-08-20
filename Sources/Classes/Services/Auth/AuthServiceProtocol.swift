// swiftlint:disable function_parameter_count line_length
public protocol AuthServiceProtocol: AnyObject {
    /// Auth password register
    ///
    ///
    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void)

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void)

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void)
}

final class AuthService: AuthServiceProtocol {

    let soulAuthProvider: SoulAuthProvider

    init(soulAuthProvider: SoulAuthProvider) {
        self.soulAuthProvider = soulAuthProvider
    }

    func passwordRegister(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = PasswordRegisterRequestParameters(login: login,
                                                           password: password,
                                                           apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                           anonymousUser: SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                                           merge: merge,
                                                           mergePreference: mergePreference)
        soulAuthProvider.request(.passwordRegister(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }

    func passwordLogin(login: String, password: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = PasswordLoginRequestParameters(login: login,
                                                        password: password,
                                                        apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                        anonymousUser: SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                                        merge: merge,
                                                        mergePreference: mergePreference)
        soulAuthProvider.request(.passwordLogin(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }

    func phoneRequest(phoneNumber: String, method: PhoneRequestMethod, completion: @escaping (Result<PhoneRequestResponse, SoulSwiftError>) -> Void) {
        let parameters = PhoneRequestParameters(phoneNumber: phoneNumber,
                                                method: method,
                                                apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                anonymousUser: SoulSwiftClient.shared.soulConfiguration.anonymousUser)
        soulAuthProvider.request(.phoneRequest(parameters: parameters)) { result in
            completion(result.map(PhoneRequestResponse.self))
        }
    }

    func phoneVerify(phoneNumber: String, code: String, method: PhoneRequestMethod, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = PhoneVerifyRequestParameters(phoneNumber: phoneNumber,
                                                      apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                      code: code,
                                                      merge: merge,
                                                      mergePreference: mergePreference)
        soulAuthProvider.request(.phoneVerify(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }

    func phoneLogin(phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = PhoneLoginRequestParameters(phoneNumber: phoneNumber,
                                                     apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                     code: code,
                                                     lastSessionToken: lastSessionToken)
        soulAuthProvider.request(.phoneLogin(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }

    func emailCodeRequest(email: String, completion: @escaping (Result<EmailCodeRequestResponse, SoulSwiftError>) -> Void) {
        let parameters = EmailCodeRequestParameters(email: email,
                                                apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                anonymousUser: SoulSwiftClient.shared.soulConfiguration.anonymousUser)
        soulAuthProvider.request(.emailCodeRequest(parameters: parameters)) { result in
            completion(result.map(EmailCodeRequestResponse.self))
        }
    }

    func emailCodeVerify(email: String, code: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = EmailCodeVerifyRequestParameters(email: email,
                                                          apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                          code: code,
                                                          merge: merge,
                                                          mergePreference: mergePreference)
        soulAuthProvider.request(.emailCodeVerify(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }

    func emailCodeExtend(email: String, code: String, lastSessionToken: String, completion: @escaping (Result<AuthResponse, SoulSwiftError>) -> Void) {
        let parameters = EmailCodeExtendRequestParameters(email: email,
                                                          apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                          code: code,
                                                          lastSessionToken: lastSessionToken)
        soulAuthProvider.request(.emailCodeExtend(parameters: parameters)) { result in
            completion(result.map(AuthResponse.self))
        }
    }
}
