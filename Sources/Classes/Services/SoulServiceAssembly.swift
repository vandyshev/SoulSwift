import Swinject
import Moya

final class SoulServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SoulApplicationServiceType.self) { _ in
            SoulApplicationService(soulApplicationProvider: MoyaProvider<SoulApplicationApi>(plugins: [NetworkLoggerPlugin(verbose: true)]))
        }
    }
}
