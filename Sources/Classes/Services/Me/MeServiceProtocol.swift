public protocol MeServiceProtocol {
//    func getMe(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class MeService: MeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
