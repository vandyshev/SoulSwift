import Moya
import Swinject
import SwinjectAutoregistration

final class MoyaProvidersAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SoulApplicationProvider.self) { resolver in
            MoyaProvider<SoulApplicationApi>(plugins: [UserAgentPlugin(),
                                                       APIVersionPlugin(),
                                                       AnonymousPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                                       HMACAuthPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                                       NetworkLoggerPlugin(verbose: true)])
        }
        container.register(SoulAuthProvider.self) { resolver in
            MoyaProvider<SoulAuthApi>(plugins: [UserAgentPlugin(),
                                                APIVersionPlugin(),
                                                AnonymousPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                                HMACAuthPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                                NetworkLoggerPlugin(verbose: true)])
        }
        container.register(SoulMeProvider.self) { resolver in
            MoyaProvider<SoulMeApi>(plugins: [UserAgentPlugin(),
                                              HMACAuthPlugin(storageService: resolver ~> StorageServiceProtocol.self),
                                              NetworkLoggerPlugin(verbose: true)])
        }
    }
}
