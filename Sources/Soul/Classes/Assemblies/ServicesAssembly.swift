import Swinject
import SwinjectAutoregistration

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(SoulApplicationServiceProtocol.self, initializer: SoulApplicationService.init).inObjectScope(.container)
        container.autoregister(SoulAuthServiceProtocol.self, initializer: SoulAuthService.init).inObjectScope(.container)
        container.autoregister(SoulMeServiceProtocol.self, initializer: SoulMeService.init).inObjectScope(.container)
        container.autoregister(SoulMeAlbumsServiceProtocol.self, initializer: SoulMeAlbumsService.init).inObjectScope(.container)
        container.autoregister(SoulUserServiceProtocol.self, initializer: SoulUserService.init).inObjectScope(.container)
        container.autoregister(SoulUsersServiceProtocol.self, initializer: SoulUsersService.init).inObjectScope(.container)
        container.autoregister(SoulChatsServiceProtocol.self, initializer: SoulChatsService.init).inObjectScope(.container)
        container.autoregister(SoulEventsServiceProtocol.self, initializer: SoulEventsService.init).inObjectScope(.container)
        container.autoregister(SoulPurchasesServiceProtocol.self, initializer: SoulPurchasesService.init).inObjectScope(.container)
        container.autoregister(SoulBlocksServiceProtocol.self, initializer: SoulBlocksService.init).inObjectScope(.container)
        container.autoregister(StorageServiceProtocol.self, initializer: StorageService.init).inObjectScope(.container)
    }
}
