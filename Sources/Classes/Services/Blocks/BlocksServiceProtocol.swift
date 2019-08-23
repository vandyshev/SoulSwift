public protocol BlocksServiceProtocol {
//    func getMe(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class BlocksService: BlocksServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
