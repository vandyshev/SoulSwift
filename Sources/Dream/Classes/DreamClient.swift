import SwinjectAutoregistration

public class DreamClient {

    public static var shared = DreamClient()

    private init() {
        errorService = resolver ~> ErrorService.self
    }

    public private(set) var chatManager: ChatManager?
    public private(set) var errorService: ErrorService

    private(set) var dreamConfiguration: DreamConfiguration!

    private let resolver = ChatDependencyConfigurator.shared.resolver

    public func setup(withDreamConfiguration dreamConfiguration: DreamConfiguration) {
        self.dreamConfiguration = dreamConfiguration
        self.chatManager = resolver.resolve(ChatManager.self, argument: DreamClient.shared.dreamConfiguration)
    }
}
