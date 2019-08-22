import Swinject
import SwinjectAutoregistration

final class ProvidersAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(SoulAuthorizationProviderProtocol.self, initializer: SoulAuthorizationProvider.init)
        container.autoregister(SoulApiVersionProviderProtocol.self, initializer: SoulApiVersionProvider.init)
        container.autoregister(SoulUserAgentProviderProtocol.self, initializer: SoulUserAgentVersionProvider.init)
        container.autoregister(SoulApiProviderProtocol.self, initializer: SoulApiProvider.init)
    }
}
