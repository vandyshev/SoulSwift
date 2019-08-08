import Foundation
import Swinject

final class DependencyConfigurator {

    static let shared = DependencyConfigurator()

    private var assembler: Assembler

    var resolver: Resolver { return assembler.resolver }

    private init() {
        assembler = Assembler([
            MoyaProvidersAssembly(),
            ServicesAssembly()
        ])
    }
}
