import Swinject
import SwinjectAutoregistration

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(ApplicationServiceProtocol.self, initializer: ApplicationService.init)
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
        container.autoregister(MeServiceProtocol.self, initializer: MeService.init)
        container.autoregister(MeAlbumsServiceProtocol.self, initializer: MeAlbumsService.init)
        container.autoregister(UserServiceProtocol.self, initializer: UserService.init)
        container.autoregister(UsersServiceProtocol.self, initializer: UsersService.init)
        container.autoregister(ChatsServiceProtocol.self, initializer: ChatsService.init)
        container.autoregister(EventsServiceProtocol.self, initializer: EventsService.init)
        container.autoregister(PurchasesServiceProtocol.self, initializer: PurchasesService.init)
        container.autoregister(BlocksServiceProtocol.self, initializer: BlocksService.init)
        container.autoregister(StorageServiceProtocol.self, initializer: StorageService.init)
    }
}
