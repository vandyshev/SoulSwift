public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    public private(set) var soulApplicationService: ApplicationServiceProtocol?
    public private(set) var soulAuthService: AuthServiceProtocol?
    public private(set) var soulMeService: MeServiceProtocol?

    private(set) var soulConfiguration: SoulConfiguration!

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(ApplicationServiceProtocol.self)
        self.soulAuthService = resolver.resolve(AuthServiceProtocol.self)
        self.soulMeService = resolver.resolve(MeServiceProtocol.self)
    }
}
