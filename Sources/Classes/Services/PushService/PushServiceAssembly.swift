import Swinject
import SwinjectAutoregistration

class PushServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocalPushServiceProtocol.self) { _ in
            if #available(iOS 10, *) {
                return LocalPushService()
            } else {
                return LocalPushServiceOld()
            }
        }
    }
}
