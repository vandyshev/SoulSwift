public protocol ChatsServiceProtocol: AnyObject {
//    func getMe(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class ChatsService: ChatsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
