public class SoulClient {

    public static var shared = SoulClient()

    public private(set) var soulApplicationService: SoulApplicationServiceProtocol?
    public private(set) var soulAuthService: SoulAuthServiceProtocol?
    public private(set) var soulMeService: SoulMeServiceProtocol?
    public private(set) var soulMeAlbumsService: SoulMeAlbumsServiceProtocol?
    public private(set) var soulUserService: SoulUserServiceProtocol?
    public private(set) var soulUsersService: SoulUsersServiceProtocol?
    public private(set) var soulChatsService: SoulChatsServiceProtocol?
    public private(set) var soulEventsService: SoulEventsServiceProtocol?
    public private(set) var soulPurchasesService: SoulPurchasesServiceProtocol?
    public private(set) var soulBlocksService: SoulBlocksServiceProtocol?

    private(set) var soulConfiguration: SoulConfiguration!

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(SoulApplicationServiceProtocol.self)
        self.soulAuthService = resolver.resolve(SoulAuthServiceProtocol.self)
        self.soulMeService = resolver.resolve(SoulMeServiceProtocol.self)
        self.soulMeAlbumsService = resolver.resolve(SoulMeAlbumsServiceProtocol.self)
        self.soulUserService = resolver.resolve(SoulUserServiceProtocol.self)
        self.soulUsersService = resolver.resolve(SoulUsersServiceProtocol.self)
        self.soulChatsService = resolver.resolve(SoulChatsServiceProtocol.self)
        self.soulEventsService = resolver.resolve(SoulEventsServiceProtocol.self)
        self.soulPurchasesService = resolver.resolve(SoulPurchasesServiceProtocol.self)
        self.soulBlocksService = resolver.resolve(SoulBlocksServiceProtocol.self)
    }
}
