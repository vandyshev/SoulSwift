import Swinject
import SwinjectAutoregistration

class ErrorServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ErrorServiceImpl.self) { _ in
            ErrorServiceImpl()
        }.inObjectScope(.container)
        container.register(ErrorService.self) { resolver in
            resolver ~> ErrorServiceImpl.self
        }
        container.register(InternalErrorService.self) { resolver in
            resolver ~> ErrorServiceImpl.self
        }
    }
}
