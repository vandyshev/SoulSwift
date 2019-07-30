import Moya

public protocol ApplicationServiceProtocol: AnyObject {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(anonymousId: String?, completion: @escaping () -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

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
