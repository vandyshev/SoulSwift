import SwinjectAutoregistration

public class DreamClient {

    public static var shared = DreamClient()

    private init() {
        errorService = resolver ~> ErrorServiceProtocol.self
    }

    public private(set) var chatManager: ChatManagerProtocol?
    public private(set) var errorService: ErrorServiceProtocol

    private(set) var soulConfiguration: SoulConfiguration!

    private let resolver = ChatDependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.chatManager = resolver.resolve(ChatManagerProtocol.self, argument: soulConfiguration)
    }
}
