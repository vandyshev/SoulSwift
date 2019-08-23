public class SoulSwiftClient {

    public static var shared = SoulSwiftClient()

    public private(set) var soulApplicationService: ApplicationServiceProtocol?
    public private(set) var soulAuthService: AuthServiceProtocol?
    public private(set) var soulMeService: MeServiceProtocol?
    public private(set) var soulUsersService: UsersServiceProtocol?
    public private(set) var soulChatsService: ChatsServiceProtocol?
    public private(set) var soulEventsService: EventsServiceProtocol?
    public private(set) var soulPurchasesService: PurchasesServiceProtocol?
    public private(set) var soulBlocksService: BlocksServiceProtocol?

    private(set) var soulConfiguration: SoulConfiguration!

    private let resolver = DependencyConfigurator.shared.resolver

    public func setup(withSoulConfiguration soulConfiguration: SoulConfiguration) {
        self.soulConfiguration = soulConfiguration
        self.soulApplicationService = resolver.resolve(ApplicationServiceProtocol.self)
        self.soulAuthService = resolver.resolve(AuthServiceProtocol.self)
        self.soulMeService = resolver.resolve(MeServiceProtocol.self)
        self.soulUsersService = resolver.resolve(UsersServiceProtocol.self)
        self.soulChatsService = resolver.resolve(ChatsServiceProtocol.self)
        self.soulEventsService = resolver.resolve(EventsServiceProtocol.self)
        self.soulPurchasesService = resolver.resolve(PurchasesServiceProtocol.self)
        self.soulBlocksService = resolver.resolve(BlocksServiceProtocol.self)
    }
}
