public protocol SoulEventsServiceProtocol {
    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping SoulResult<[Event]>.Completion)
}

final class SoulEventsService: SoulEventsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func events(since: TimeInterval?, until: TimeInterval?, limit: Int?, ascending: Bool, completion: @escaping SoulResult<[Event]>.Completion) {
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
