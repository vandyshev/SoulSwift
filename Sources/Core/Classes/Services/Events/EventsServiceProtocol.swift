// swiftlint:disable line_length
public protocol EventsServiceProtocol {
    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping (Result<[Event], SoulSwiftError>) -> Void)
}

final class EventsService: EventsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping (Result<[Event], SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            soulEndpoint: SoulEventsEndpoint.events,
            needAuthorization: true
        )
        request.setQueryParameters(["since": since,
                                    "until": until,
                                    "limit": limit,
                                    "ascending": ascending])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.events })
        }
    }
}
