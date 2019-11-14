public protocol SoulUsersServiceProtocol {

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping SoulResult<[User]>.Completion)

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter, settings: Settings, completion: @escaping SoulResult<[User]>.Completion)
}

final class SoulUsersService: SoulUsersServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping SoulResult<[User]>.Completion) {
        var request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.recommendationsList,
            needAuthorization: true
        )
        request.setQueryParameters(["uniqueToken": uniqueToken,
                                    "viewingSession": viewingSession,
                                    "limit": limit])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter, settings: Settings, completion: @escaping SoulResult<[User]>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.recommendationsList,
            needAuthorization: true
        )
        request.setQueryParameters(["anonymousUser": SoulClient.shared.soulConfiguration.anonymousUser,
                                    "apiKey": SoulClient.shared.soulConfiguration.apiKey])
        request.setBodyParameters(["filter": filter, "settings": settings])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }
}
