public protocol MeServiceProtocol: AnyObject {
//    func getMe(completion: @escaping () -> Void)
}

final class MeService: MeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }
}
