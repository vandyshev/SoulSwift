typealias CompletionHandler = (Result<SoulResponse, SoulSwiftError>) -> Void
protocol SoulRefreshTokenProviderProtocol {

    var isTokenRefreshing: Bool { get }
    func isNeedRefreshToken(for response: URLResponse?) -> Bool
    func refreshToken(provider: SoulProvider, request: SoulRequest, completion: @escaping CompletionHandler)
}

class SoulRefreshTokenProvider: SoulRefreshTokenProviderProtocol {

    var isTokenRefreshing = false
    private var requestStorage: [(SoulRequest, CompletionHandler)] = []
    private var authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
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
            requestRefreshToken { [weak self] in
                self?.isTokenRefreshing = false
                self?.requestStorage.forEach { item in
                    provider.request(item.0, completion: item.1)
                }
            }
        }
    }

    private func requestRefreshToken(completion: @escaping () -> Void) {
        authService.emailCodeExtend(email: "email", code: "code", lastSessionToken: "token") { _ in
            completion()
        }
    }
}
