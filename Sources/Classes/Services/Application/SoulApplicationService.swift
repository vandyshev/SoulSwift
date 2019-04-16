import Moya

final class SoulApplicationService: SoulApplicationServiceType {

    let soulApplicationProvider: MoyaProvider<SoulApplicationApi>

    init(soulApplicationProvider: MoyaProvider<SoulApplicationApi>) {
        self.soulApplicationProvider = soulApplicationProvider
    }

    func features(anonymousId: String?, completion: @escaping () -> Void) {
        soulApplicationProvider.request(.features(anonymousId: anonymousId)) { _ in
            completion()
        }
    }
}
