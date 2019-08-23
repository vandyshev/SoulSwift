public protocol EventsServiceProtocol {
    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping (Result<[Event], SoulSwiftError>) -> Void)
}

final class EventsService: EventsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping (Result<[Event], SoulSwiftError>) -> Void) {

    }
}
