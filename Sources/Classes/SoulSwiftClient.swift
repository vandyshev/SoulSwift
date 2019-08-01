import SwinjectAutoregistration

public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    private init() {
        errorService = resolver ~> ErrorServiceProtocol.self
    }

    public private(set) var soulApplicationService: ApplicationServiceProtocol?
    public private(set) var soulMeService: MeServiceProtocol?
    public private(set) var chatManager: ChatManagerProtocol?
    public private(set) var errorService: ErrorServiceProtocol

    private(set) var soulConfiguration: SoulConfiguration!

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(ApplicationServiceProtocol.self)
        self.soulMeService = resolver.resolve(MeServiceProtocol.self)
        self.chatManager = resolver.resolve(ChatManagerProtocol.self, argument: soulConfiguration)
    }
}
