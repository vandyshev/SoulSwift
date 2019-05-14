public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()
    
    private init() { }

    public var soulApplicationService: SoulApplicationService?
    public private(set) lazy var chatManager: ChatManager? = {
        guard let soulConfiguration = soulConfiguration else { return nil }
        return resolver.resolve(ChatManager.self, argument: soulConfiguration)
    }() // TODO: redo

    private(set) var soulConfiguration: SoulConfiguration?

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(SoulApplicationService.self)
    }
}
