import Moya

public protocol AuthServiceProtocol: AnyObject {
    /// Auth password register
    ///
    ///
    func passwordRegister(login: String, passwd: String, completion: @escaping () -> Void)

    func passwordRegister(login: String, passwd: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping () -> Void)
}

final class AuthService: AuthServiceProtocol {

    let soulAuthProvider: SoulAuthProvider

    init(soulAuthProvider: SoulAuthProvider) {
        self.soulAuthProvider = soulAuthProvider
    }

    func passwordRegister(login: String, passwd: String, completion: @escaping () -> Void) {
        passwordRegister(login: login, passwd: passwd, merge: nil, mergePreference: nil, completion: completion)
    }

    func passwordRegister(login: String, passwd: String, merge: Bool?, mergePreference: MergePreference?, completion: @escaping () -> Void) {
        let parameters = PasswordRegisterRequestParameters(login: login,
                                                           passwd: passwd,
                                                           apiKey: SoulSwiftClient.shared.soulConfiguration.apiKey,
                                                           anonymousUser: SoulSwiftClient.shared.soulConfiguration.anonymousUser,
                                                           merge: merge,
                                                           mergePreference: mergePreference)
        soulAuthProvider.request(.passwordRegister(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                break
            case .failure(let moyaError):
                break
            }
        }
    }
}
