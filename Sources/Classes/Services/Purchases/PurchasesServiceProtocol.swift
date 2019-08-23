public protocol PurchasesServiceProtocol {
//    func getMe(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
}

final class PurchasesService: PurchasesServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
