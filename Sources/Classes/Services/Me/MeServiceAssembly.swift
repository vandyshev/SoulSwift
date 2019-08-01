import Swinject
import SwinjectAutoregistration
import Moya

final class MeServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MeServiceProtocol.self) { resolver in
            MeService(soulMeProvider:
                MoyaProvider<SoulMeApi>(
                    plugins: [
                        HMACAuthPlugin(storage: resolver ~> Storage.self),
                        UserAgentPlugin(),
                        NetworkLoggerPlugin(verbose: true)
                    ]
                )
            )
        }
    }
}
