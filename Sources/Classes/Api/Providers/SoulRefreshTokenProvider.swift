import Foundation

typealias CompletionHandler = (Result<SoulResponse, SoulSwiftError>) -> Void

protocol SoulRefreshTokenProviderProtocol {

    var isTokenRefreshing: Bool { get }
    func isNeedRefreshToken(for response: URLResponse?) -> Bool
    func refreshToken(provider: SoulProvider, request: SoulRequest, completion: @escaping CompletionHandler)
}
// swiftlint:disable line_length
class SoulRefreshTokenProvider: SoulRefreshTokenProviderProtocol {

    var isTokenRefreshing = false

    private var storageService: StorageServiceProtocol

    private var isTokenHasBeenUpdated = false
    private var requestStorage: [(SoulRequest, CompletionHandler)] = []

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func isNeedRefreshToken(for response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else { return false }
        return httpResponse.statusCode == 401
    }

    func refreshToken(provider: SoulProvider, request: SoulRequest, completion: @escaping CompletionHandler) {
        if isTokenRefreshing {
            requestStorage.append((request, completion))
        } else {
            isTokenRefreshing = true
            requestStorage.append((request, completion))
            requestRefreshToken(provider: provider) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.isTokenRefreshing = false
                while sSelf.requestStorage.count > 0 {
                    let item = sSelf.requestStorage.removeFirst()
                    provider.request(refreshToken: false, item.0, completion: item.1)
                }
            }
        }
    }

    private func requestRefreshToken(provider: SoulProvider, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        guard let credential = storageService.credential else {
            completion(.failure(SoulSwiftError.refreshToken))
            return
        }
        let sessionToken = credential.authorization.sessionToken
        switch credential.method {
        case .password:
            completion(.failure(SoulSwiftError.refreshToken))
        case .phone(let phoneNumber, let code):
            phoneLogin(provider: provider, phoneNumber: phoneNumber, code: code, lastSessionToken: sessionToken, completion: completion)
        case .email(let email, let code):
            emailCodeExtend(provider: provider, email: email, code: code, lastSessionToken: sessionToken, completion: completion)
        }
    }

    private func phoneLogin(provider: SoulProvider, phoneNumber: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.phoneLogin
        )
        request.setBodyParameters(["phoneNumber": phoneNumber,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "lastSessionToken": lastSessionToken])
        provider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .phone(phoneNumber: phoneNumber, code: code),
                    with: self?.saveAuthorization
                )
            )
        }
    }

    private func emailCodeExtend(provider: SoulProvider, email: String, code: String, lastSessionToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulAuthEndpoint.emailCodeExtend
        )
        request.setBodyParameters(["email": email,
                                   "code": code,
                                   "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey,
                                   "lastSessionToken": lastSessionToken])
        provider.request(request) { [weak self] (result: Result<SoulResponse, SoulSwiftError>) in
            completion(
                result.afterSaveAuthorization(
                    for: .email(email: email, code: code),
                    with: self?.saveAuthorization
                )
            )
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
