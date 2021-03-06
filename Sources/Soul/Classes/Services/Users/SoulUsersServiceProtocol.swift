// swiftlint:disable function_parameter_count
public protocol SoulUsersServiceProtocol {

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping SoulResult<[User]>.Completion)

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter?, settings: Settings?, completion: @escaping SoulResult<Void>.Completion)

    // GET: /users/set/{filterName}
    func setFilterName(filterName: String,
                       offset: Int?,
                       limit: Int?,
                       before: TimeInterval?,
                       since: TimeInterval?,
                       countOnly: Bool?,
                       completion: @escaping SoulResult<([User], Meta)>.Completion)

    // PATCH: /users/set/{filterName}/filter
    func setFilterNameFilter(filterName: String, user: Filter?, completion: @escaping SoulResult<Void>.Completion)
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
    func setRecommendationsFilter(filter: Filter?, settings: Settings?, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.recommendationsFilter,
            needAuthorization: true
        )
        request.setBodyParameters(["filter": filter?.filter, "settings": settings?.settings])
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    // GET: /users/set/{filterName}
    func setFilterName(filterName: String,
                       offset: Int?,
                       limit: Int?,
                       before: TimeInterval?,
                       since: TimeInterval?,
                       countOnly: Bool?,
                       completion: @escaping SoulResult<([User], Meta)>.Completion) {
        var request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.setFilterName(filterName: filterName),
            needAuthorization: true
        )
        request.setQueryParameters(["count_only": countOnly,
                                    "offset": offset,
                                    "limit": limit,
                                    "before": before,
                                    "since": since])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.users, $0.meta) })
        }
    }

    // PATCH: /users/set/{filterName}/filter
    func setFilterNameFilter(filterName: String, user: Filter?, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.setFilterNameFilter(filterName: filterName),
            needAuthorization: true
        )
        request.setBodyParameters(["user": user?.filter])
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }
}
