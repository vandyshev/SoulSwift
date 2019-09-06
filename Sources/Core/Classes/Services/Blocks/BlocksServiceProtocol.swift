public protocol BlocksServiceProtocol {
    func koth(completion: @escaping (Result<User, SoulSwiftError>) -> Void)
}

final class BlocksService: BlocksServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func koth(completion: @escaping (Result<User, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulBlocksEndpoint.soulKoth,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.currentKing })
        }
    }
}
