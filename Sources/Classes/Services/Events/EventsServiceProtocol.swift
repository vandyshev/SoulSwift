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
        let queryParameters: [String: Any?] = [
            "since": since,
            "until": until,
            "limit": limit,
            "ascending": ascending
        ]
        let request = SoulRequest(
            soulEndpoint: SoulEventsEndpoint.events,
            queryParameters: queryParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.events })
        }
    }
}
