import Swinject
import Moya

final class StorageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StorageServiceProtocol.self) { _ in
            StorageService()
        }
    }
}
