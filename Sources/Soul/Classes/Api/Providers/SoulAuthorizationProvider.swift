import CryptoSwift
import Foundation

protocol SoulAuthorizationProviderProtocol {
    var isAuthorized: Bool { get }
    var account: String? { get }
    func authorize(_ request: URLRequest) -> URLRequest
    func saveAuthorization(method: AuthMethod, authorization: Authorization, me: MyUser)
    func removeAuthorization()
}

class SoulAuthorizationProvider: SoulAuthorizationProviderProtocol {

    private var storageService: StorageServiceProtocol
    private var soulDateProvider: SoulDateProviderProtocol

    var isAuthorized: Bool {
        let userId = storageService.credential?.me.id ?? storageService.legacyUserId
        let seesionToken = storageService.credential?.authorization.sessionToken ?? storageService.legacySessionToken
        return userId != nil && storageService != nil
    }

    var account: String? {
        return storageService.credential?.method.account
    }

    init(storageService: StorageServiceProtocol,
         soulDateProvider: SoulDateProviderProtocol) {
        self.storageService = storageService
        self.soulDateProvider = soulDateProvider
    }

    func authorize(_ request: URLRequest) -> URLRequest {
        guard let authorization = getAuthorization(request) else { return request }
        var request = request
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        return request
    }

    func saveAuthorization(method: AuthMethod, authorization: Authorization, me: MyUser) {
        let credential = SoulCredential(method: method, authorization: authorization, me: me)
        storageService.credential = credential
        storageService.legacyUserId = me.id
        storageService.legacySessionToken = authorization.sessionToken
    }

    func removeAuthorization() {
        storageService.credential = nil
        storageService.legacyUserId = nil
        storageService.legacySessionToken = nil
    }

    private func getAuthorization(_ request: URLRequest) -> String? {
        guard let userId = storageService.credential?.me.id ?? storageService.legacyUserId else { return nil }
        guard var sessionToken = storageService.credential?.authorization.sessionToken ?? storageService.legacySessionToken else { return nil }
        guard let httpMethod = request.httpMethod else { return nil }
        guard let url = request.url else { return nil }
        guard let httpPath = httpPath(for: url) else { return nil }
        let httpBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        let adjustedTimestamp = soulDateProvider.currentAdjustedDate.timeIntervalSince1970
        let unixtime = "\(Int(round(adjustedTimestamp)))"
        guard let digest = hmacSHA256(from: "\(httpMethod)+\(httpPath)+\(httpBody)+\(unixtime)", key: sessionToken) else { return nil }
        return "hmac \(userId):\(unixtime):\(digest)"
    }

    private func httpPath(for url: URL) -> String? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.scheme = nil
        urlComponents?.host = nil
        return urlComponents?.url?.absoluteString
    }

    private func hmacSHA256(from string: String, key: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        let key: [UInt8] = Array(key.utf8)
        return try? HMAC(key: key, variant: .sha256).authenticate(data.bytes).toHexString()
    }
}
