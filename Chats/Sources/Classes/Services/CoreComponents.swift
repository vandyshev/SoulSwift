import Foundation
import Swinject
import SwinjectAutoregistration

final class CoreComponents: Assembly {

    func assemble(container: Container) {

        container.register(Storage.self) { _ in
            SoulSDKCommonStorage()
        }

        container.register(DeviceIdStorage.self) { _ in
            SoulSDKCommonStorage()
        }

        container.register(DeviceHandlerProtocol.self) { resolver in
            DeviceHandler(storage: resolver~>)
        }

        container.register(AuthHelperProtocol.self) { (resolver: Resolver, appName: String) in
            AuthHelper(storage: resolver~>,
                           dateService: resolver~>,
                           appName: appName)
        }

        container.register(DateServiceProtocol.self) { resolver in
            DateService(storage: resolver~>)
        }
    }
}
