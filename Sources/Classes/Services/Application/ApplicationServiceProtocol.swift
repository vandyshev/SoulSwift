public protocol ApplicationServiceProtocol: AnyObject {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void)

    func constants(namespace: String, completion: @escaping () -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void) {
        let queryItems = [
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let request = SoulRequest(
            httpMethod: .GET,
            soulEndpoint: SoulApplicationEndpoint.features,
            queryItems: queryItems,
            bodyParameters: nil,
            needAuthorization: false
        )
        soulProvider.request(request) { (result: Result<Features, SoulSwiftError>) in
            completion(result.map { $0.features })
        }
    }

    func constants(namespace: String, completion: @escaping () -> Void) {

    }
}
