import Moya

public protocol ApplicationServiceProtocol: AnyObject {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping () -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

    let soulApplicationProvider: SoulApplicationProvider

    init(soulApplicationProvider: SoulApplicationProvider) {
        self.soulApplicationProvider = soulApplicationProvider
    }

    func features(completion: @escaping () -> Void) {
        soulApplicationProvider.request(.features) { _ in
            completion()
        }
    }
}
