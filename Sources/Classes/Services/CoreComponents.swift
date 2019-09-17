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

        container.register(DeviceHandler.self) { resolver in
            DeviceHandlerImpl(storage: resolver~>)
        }

        container.register(AuthHelper.self) { (resolver: Resolver, appName: String) in
            AuthHelperImpl(storage: resolver~>,
                           dateService: resolver~>,
                           appName: appName)
        }

        container.register(DateService.self) { resolver in
            DateServiceImpl(storage: resolver~>)
        }
    }
}