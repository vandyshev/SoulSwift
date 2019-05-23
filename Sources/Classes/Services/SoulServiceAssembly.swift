import Swinject
import Moya

final class SoulServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SoulApplicationService.self) { _ in
            SoulApplicationServiceImpl(soulApplicationProvider: MoyaProvider<SoulApplicationApi>(plugins: [NetworkLoggerPlugin(verbose: true)]))
        }
    }
}
