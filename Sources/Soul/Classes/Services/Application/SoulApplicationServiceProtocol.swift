public protocol SoulApplicationServiceProtocol {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void)
}

final class SoulApplicationService: SoulApplicationServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void) {
        let queryParameters = [
            "anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulClient.shared.soulConfiguration.apiKey
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
