import CommonCrypto

protocol SoulAuthorizationProviderProtocol {
    func authorize(_ request: URLRequest) -> URLRequest
}

struct SoulAuthorizationProvider: SoulAuthorizationProviderProtocol {

    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func authorize(_ request: URLRequest) -> URLRequest {
        guard let authorization = getAuthorization(request) else { return request }
        var request = request
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        return request
    }

    private func getAuthorization(_ request: URLRequest) -> String? {
        guard let userId = storageService.userId else { return nil }
        guard let sessionToken = storageService.sessionToken else { return nil }
        guard let httpMethod = request.httpMethod else { return nil }
        guard let httpPath = request.url?.path else { return nil }
        let httpBody = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        // TODO: adjust timestamp
        let unixtime = "\(Int(round(Date().timeIntervalSince1970)))"
        let digest = hmacSHA256(from: "\(httpMethod)+\(httpPath)+\(httpBody)+\(unixtime)", key: sessionToken)
        return "hmac \(userId):\(unixtime):\(digest)"
    }

    private func hmacSHA256(from string: String, key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, string, string.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}
