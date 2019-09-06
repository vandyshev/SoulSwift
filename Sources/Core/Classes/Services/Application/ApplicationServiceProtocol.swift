public protocol ApplicationServiceProtocol {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void) {
        let queryParameters = [
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let request = SoulRequest(
            soulEndpoint: SoulApplicationEndpoint.features,
            queryParameters: queryParameters
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.features?.features })
        }
    }
}
