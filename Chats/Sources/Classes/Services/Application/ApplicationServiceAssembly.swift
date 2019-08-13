import Swinject
import Moya

final class ApplicationServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ApplicationServiceProtocol.self) { _ in
            ApplicationService(soulApplicationProvider:
                MoyaProvider<SoulApplicationApi>(
                    plugins: [
                        UserAgentPlugin(),
                        NetworkLoggerPlugin(verbose: true)
                    ]
                )
            )
        }
    }
}
