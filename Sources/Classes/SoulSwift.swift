public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    public var soulApplicationService: SoulApplicationService?
    public private(set) lazy var chatManager: ChatManager? = {
        resolver.resolve(ChatManager.self, argument: self.soulConfiguration)
    }() // TODO: redo

    private(set) var soulConfiguration: SoulConfiguration?

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(SoulApplicationService.self)
    }
}
