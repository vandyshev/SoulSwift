import Moya

public protocol ApplicationServiceProtocol: AnyObject {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void)

    func constants(namespace: String, completion: @escaping () -> Void)
}

final class ApplicationService: ApplicationServiceProtocol {

    let soulApplicationProvider: SoulApplicationProvider

    init(soulApplicationProvider: SoulApplicationProvider) {
        self.soulApplicationProvider = soulApplicationProvider
    }

    func features(completion: @escaping (Result<[Feature], SoulSwiftError>) -> Void) {
        soulApplicationProvider.request(.features) { result in
            completion(result.map(Features.self).map { $0.features })
        }
    }

    func constants(namespace: String, completion: @escaping () -> Void) {
        soulApplicationProvider.request(.constants(namespace: namespace)) { _ in
            completion()
        }
    }
}
