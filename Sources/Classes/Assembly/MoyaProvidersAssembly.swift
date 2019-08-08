import Foundation
import Swinject
import SwinjectAutoregistration
import Moya

final class MoyaProvidersAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SoulApplicationProvider.self) { _ in
            MoyaProvider<SoulApplicationApi>(plugins: [UserAgentPlugin(), APIVersionPlugin(), AnonymousPlugin(), NetworkLoggerPlugin(verbose: true)])
        }
        container.register(SoulMeProvider.self) { resolver in
            MoyaProvider<SoulMeApi>(plugins: [UserAgentPlugin(),
                                              HMACAuthPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                              NetworkLoggerPlugin(verbose: true)])
        }
    }
}
