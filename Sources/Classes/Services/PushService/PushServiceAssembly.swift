import Swinject
import SwinjectAutoregistration

class PushServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocalPushService.self) { _ in
            if #available(iOS 10, *) {
                return LocalPushServiceImpl()
            } else {
                return LocalPushServiceOldImpl()
            }
        }
    }
}
