public protocol SoulUsersServiceProtocol {

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping SoulResult<[User]>.Completion)

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter?, settings: Settings?, completion: @escaping SoulResult<[User]>.Completion)

    // GET: /users/recommendations/set/{filterName}
    func recommendationsSetFilterName(filterName: String,
                                      offset: Int?,
                                      limit: Int?,
                                      before: TimeInterval?,
                                      since: TimeInterval?,
                                      countOnly: Bool?,
                                      completion: @escaping SoulResult<([User], Meta)>.Completion)

    // PATCH: /users/recommendations/set/{filterName}/filter
    func setRecommendationsFilter(filterName: String, user: Filter?, completion: @escaping SoulResult<[User]>.Completion)
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
    func setRecommendationsFilter(filter: Filter?, settings: Settings?, completion: @escaping SoulResult<[User]>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.recommendationsList,
            needAuthorization: true
        )
        request.setBodyParameters(["filter": filter, "settings": settings])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }

    // GET: /users/recommendations/set/{filterName}
    func recommendationsSetFilterName(filterName: String,
                                      offset: Int?,
                                      limit: Int?,
                                      before: TimeInterval?,
                                      since: TimeInterval?,
                                      countOnly: Bool?,
                                      completion: @escaping SoulResult<([User], Meta)>.Completion) {
        var request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.recommendationsSetFilterName(filterName: filterName),
            needAuthorization: true
        )
        request.setQueryParameters(["count_only": countOnly,
                                    "offset": offset,
                                    "limit": limit,
                                    "before": before,
                                    "since": since])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.users, $0._meta) })
        }
    }

    // PATCH: /users/recommendations/set/{filterName}/filter
    func setRecommendationsFilter(filterName: String, user: Filter?, completion: @escaping SoulResult<[User]>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.recommendationsSetFilterNameFilter(filterName: filterName),
            needAuthorization: true
        )
        request.setBodyParameters(["user": user])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }
}
