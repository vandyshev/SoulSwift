import Moya

protocol AnonymousTargetType: TargetType {
    var needsAnonymous: Bool { get }
}

struct AnonymousPlugin: PluginType {

    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? AnonymousTargetType, target.needsAnonymous else { return request }
        guard storageService.userId == nil else { return request }
        guard storageService.sessionToken == nil else { return request }
        var request = request
        if let url = request.url, var urlComponents = URLComponents(string: url.absoluteString) {
            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: "anonymousUser", value: SoulSwiftClient.shared.soulConfiguration.anonymousUser))
            queryItems.append(URLQueryItem(name: "apiKey", value: SoulSwiftClient.shared.soulConfiguration.apiKey))
            urlComponents.queryItems = queryItems
            request.url = urlComponents.url
        }
        return request
    }
}
