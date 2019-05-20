public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    private init() { }

    public private(set) var soulApplicationService: SoulApplicationService?
    public private(set) var chatManager: ChatManager?

    public private(set) var chatPushManager: ChatLocalPushManager?

    private(set) var soulConfiguration: SoulConfiguration?

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(SoulApplicationService.self)

        self.chatManager = resolver.resolve(ChatManager.self, argument: soulConfiguration)
        self.chatPushManager = resolver.resolve(ChatLocalPushManager.self, argument: soulConfiguration)
    }
}
