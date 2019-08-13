import Moya

public protocol MeServiceProtocol: AnyObject {
    func getMe(completion: @escaping () -> Void)
}

final class MeService: MeServiceProtocol {

    let soulMeProvider: MoyaProvider<SoulMeApi>

    init(soulMeProvider: MoyaProvider<SoulMeApi>) {
        self.soulMeProvider = soulMeProvider
    }

    func getMe(completion: @escaping () -> Void) {
        soulMeProvider.request(.me(.get)) { _ in
            completion()
        }
    }
}
