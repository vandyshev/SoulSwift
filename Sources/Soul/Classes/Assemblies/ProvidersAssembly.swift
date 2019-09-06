import Swinject
import SwinjectAutoregistration

final class ProvidersAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(SoulAuthorizationProviderProtocol.self, initializer: SoulAuthorizationProvider.init).inObjectScope(.container)
        container.autoregister(SoulApiVersionProviderProtocol.self, initializer: SoulVersionProvider.init).inObjectScope(.container)
        container.autoregister(SoulUserAgentProviderProtocol.self, initializer: SoulUserAgentVersionProvider.init).inObjectScope(.container)
        container.autoregister(SoulRefreshTokenProviderProtocol.self, initializer: SoulRefreshTokenProvider.init).inObjectScope(.container)
        container.autoregister(SoulProviderProtocol.self, initializer: SoulProvider.init).inObjectScope(.container)
    }
}
