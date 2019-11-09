public protocol SoulBlocksServiceProtocol {
    func koth(completion: @escaping SoulResult<User>.Completion)
}

final class SoulBlocksService: SoulBlocksServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func koth(completion: @escaping SoulResult<User>.Completion) {
        let request = SoulRequest(
            soulEndpoint: SoulBlocksEndpoint.soulKoth,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.currentKing })
        }
    }
}
