import Swinject
import SwinjectAutoregistration

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(ApplicationServiceProtocol.self, initializer: ApplicationService.init).inObjectScope(.container)
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init).inObjectScope(.container)
        container.autoregister(MeServiceProtocol.self, initializer: MeService.init).inObjectScope(.container)
        container.autoregister(MeAlbumsServiceProtocol.self, initializer: MeAlbumsService.init).inObjectScope(.container)
        container.autoregister(UserServiceProtocol.self, initializer: UserService.init).inObjectScope(.container)
        container.autoregister(UsersServiceProtocol.self, initializer: UsersService.init).inObjectScope(.container)
        container.autoregister(ChatsServiceProtocol.self, initializer: ChatsService.init).inObjectScope(.container)
        container.autoregister(EventsServiceProtocol.self, initializer: EventsService.init).inObjectScope(.container)
        container.autoregister(PurchasesServiceProtocol.self, initializer: PurchasesService.init).inObjectScope(.container)
        container.autoregister(BlocksServiceProtocol.self, initializer: BlocksService.init).inObjectScope(.container)
        container.autoregister(StorageServiceProtocol.self, initializer: StorageService.init).inObjectScope(.container)
    }
}
