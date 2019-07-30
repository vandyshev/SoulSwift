import Swinject
import SwinjectAutoregistration

class ErrorServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ErrorService.self) { _ in
            ErrorService()
        }.inObjectScope(.container)
        container.register(ErrorServiceProtocol.self) { resolver in
            resolver ~> ErrorService.self
        }
        container.register(InternalErrorService.self) { resolver in
            resolver ~> ErrorService.self
        }
    }
}
