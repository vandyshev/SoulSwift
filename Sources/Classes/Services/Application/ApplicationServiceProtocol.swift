public protocol ApplicationServiceProtocol: AnyObject {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void)

    func constants(namespace: String, completion: @escaping () -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

    let soulApiProvider: SoulApiProviderProtocol

    init(soulApiProvider: SoulApiProviderProtocol) {
        self.soulApiProvider = soulApiProvider
    }

    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void) {
        let queryItems = [
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let request = SoulApiRequest(
            httpMethod: .GET,
            soulApiEndpoint: SoulApplicationApiEndpoint.features,
            queryItems: queryItems,
            bodyParameters: nil,
            needAuthorization: false
        )
        soulApiProvider.request(request) { (result: Result<Features, SoulSwiftError>) in
            completion(result.map { $0.features })
        }
    }

    func constants(namespace: String, completion: @escaping () -> Void) {

    }
}
