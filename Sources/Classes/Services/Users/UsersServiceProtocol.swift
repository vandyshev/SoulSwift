public protocol UsersServiceProtocol {
//    func getMe(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class UsersService: UsersServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
