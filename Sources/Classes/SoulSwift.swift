public class SoulSwift {

    public static var shared = SoulSwift()

    public var soulApplicationService: SoulApplicationService?
    public var chatService: ChatService?

    private(set) var soulConfiguration: SoulConfiguration?

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(SoulApplicationService.self)
        self.chatService = resolver.resolve(ChatService.self, argument: soulConfiguration)
    }
}
