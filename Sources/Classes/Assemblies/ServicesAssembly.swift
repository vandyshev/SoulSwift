import Swinject
import SwinjectAutoregistration

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(ApplicationServiceProtocol.self, initializer: ApplicationService.init)
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
        container.autoregister(MeServiceProtocol.self, initializer: MeService.init)
        container.autoregister(StorageServiceProtocol.self, initializer: StorageService.init)
    }
}
