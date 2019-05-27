import Swinject
import Moya

final class ApplicationServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ApplicationService.self) { _ in
            ApplicationServiceImpl(soulApplicationProvider: MoyaProvider<SoulApplicationApi>(plugins: [NetworkLoggerPlugin(verbose: true)]))
        }
    }
}
