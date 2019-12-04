import Foundation
import Swinject

final class ChatDependencyConfigurator {

    static let shared = ChatDependencyConfigurator()

    private var assembler: Assembler

    var resolver: Resolver { return assembler.resolver }

    private init() {
        assembler = Assembler([
            CoreComponents(),
            ChatAssembly(),
            PushServiceAssembly(),
            ErrorServiceAssembly()
        ])
    }
}
