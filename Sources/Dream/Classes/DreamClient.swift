import SwinjectAutoregistration

public class DreamClient {

    public static var shared = DreamClient()

    private init() {
        errorService = resolver ~> ErrorServiceProtocol.self
    }

    public private(set) var chatManager: ChatManagerProtocol?
    public private(set) var errorService: ErrorServiceProtocol

    private(set) var dreamConfiguration: DreamConfiguration!

    private let resolver = ChatDependencyConfigurator.shared.resolver

    public func setup(withDreamConfiguration dreamConfiguration: DreamConfiguration) {
        self.dreamConfiguration = dreamConfiguration
        self.chatManager = resolver.resolve(ChatManagerProtocol.self, argument: SoulClient.shared.soulConfiguration)
    }
}
