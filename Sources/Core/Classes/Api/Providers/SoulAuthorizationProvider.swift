import CommonCrypto

protocol SoulAuthorizationProviderProtocol {
    var isAuthorized: Bool { get }
    var account: String? { get }
    func authorize(_ request: URLRequest) -> URLRequest
    func saveAuthorization(method: AuthMethod, authorization: Authorization, me: MyUser)
}

class SoulAuthorizationProvider: SoulAuthorizationProviderProtocol {

    private var storageService: StorageServiceProtocol

    var isAuthorized: Bool {
        let userId = storageService.credential?.me.id ?? storageService.legacyUserId
        let seesionToken = storageService.credential?.authorization.sessionToken ?? storageService.legacySessionToken
        return userId != nil && storageService != nil
    }

    var account: String? {
        return storageService.credential?.method.account
    }

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
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

    private func getAuthorization(_ request: URLRequest) -> String? {
        guard let userId = storageService.credential?.me.id ?? storageService.legacyUserId else { return nil }
        guard var sessionToken = storageService.credential?.authorization.sessionToken ?? storageService.legacySessionToken else { return nil }
        guard let httpMethod = request.httpMethod else { return nil }
        guard let url = request.url else { return nil }
        guard let httpPath = httpPath(for: url) else { return nil }
        let httpBody = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        // TODO: adjust timestamp
        let unixtime = "\(Int(round(Date().timeIntervalSince1970)))"
        let digest = hmacSHA256(from: "\(httpMethod)+\(httpPath)+\(httpBody)+\(unixtime)", key: sessionToken)
        return "hmac \(userId):\(unixtime):\(digest)"
    }

    private func httpPath(for url: URL) -> String? {
        var urlComponents = URLComponents()
        urlComponents.path = url.path
        urlComponents.query = url.query
        urlComponents.fragment = url.fragment
        return urlComponents.url?.absoluteString
    }

    private func hmacSHA256(from string: String, key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, string, string.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}
