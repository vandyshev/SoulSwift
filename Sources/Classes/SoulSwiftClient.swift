import SwinjectAutoregistration

public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    private init() {
        errorService = resolver ~> ErrorService.self
    }

    public private(set) var soulApplicationService: ApplicationService?
    public private(set) var chatManager: ChatManager?
    public private(set) var errorService: ErrorService

    private(set) var soulConfiguration: SoulConfiguration?

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(ApplicationService.self)
        self.chatManager = resolver.resolve(ChatManager.self, argument: soulConfiguration)
    }
}
