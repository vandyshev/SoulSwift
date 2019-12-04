public protocol SoulApplicationServiceProtocol {
    // GET: /application/features
    func features(completion: @escaping SoulResult<[Feature]>.Completion)

    func additionalInfo(completion: @escaping SoulResult<AdditionalInfo?>.Completion)
}

final class SoulApplicationService: SoulApplicationServiceProtocol {

    let soulProvider: SoulProviderProtocol
    let soulAdditionalInfoProvider: SoulAdditionalInfoProviderProtocol

    init(soulProvider: SoulProviderProtocol,
         soulAdditionalInfoProvider: SoulAdditionalInfoProviderProtocol) {
        self.soulProvider = soulProvider
        self.soulAdditionalInfoProvider = soulAdditionalInfoProvider
    }

    func features(completion: @escaping SoulResult<[Feature]>.Completion) {
        // SoulSwift: Добавить needAuthorization: true если авторизован
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

    func additionalInfo(completion: @escaping (SoulResult<AdditionalInfo?>) -> Void) {
        completion(.success(soulAdditionalInfoProvider.additionalInfo))
    }
}
