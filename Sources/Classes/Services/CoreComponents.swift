import Foundation
import Swinject
import SwinjectAutoregistration

final class CoreComponents: Assembly {

    func assemble(container: Container) {

        container.register(Storage.self) { _ in
            SoulSDKCommonStorage()
        }

        container.register(AuthHelper.self) { (resolver: Resolver, appName: String) in
            AuthHelperImpl(storage: resolver~>,
                           appName: appName)
        }
    }
}
