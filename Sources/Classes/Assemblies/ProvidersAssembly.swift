import Swinject
import SwinjectAutoregistration

final class ProvidersAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(SoulAuthorizationProviderProtocol.self, initializer: SoulAuthorizationProvider.init)
        container.autoregister(SoulApiVersionProviderProtocol.self, initializer: SoulVersionProvider.init)
        container.autoregister(SoulUserAgentProviderProtocol.self, initializer: SoulUserAgentVersionProvider.init)
        container.autoregister(SoulRefreshTokenProviderProtocol.self, initializer: SoulRefreshTokenProvider.init)
        container.autoregister(SoulProviderProtocol.self, initializer: SoulProvider.init)
    }
}
