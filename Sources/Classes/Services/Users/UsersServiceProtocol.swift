// swiftlint:disable line_length
public protocol UsersServiceProtocol {

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping (Result<[User], SoulSwiftError>) -> Void)

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter, settings: Settings, completion: @escaping (Result<[User], SoulSwiftError>) -> Void)
}

final class UsersService: UsersServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    // GET: /users/recommendations/list
    func recommendationsList(uniqueToken: String?, viewingSession: String?, limit: Int?, completion: @escaping (Result<[User], SoulSwiftError>) -> Void) {
        let queryParameters: [String: Any] = [
            "uniqueToken": uniqueToken,
            "viewingSession": viewingSession,
            "limit": limit
        ]
        let request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.recommendationsList,
            queryParameters: queryParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }

    // PATCH: /users/recommendations/filter
    func setRecommendationsFilter(filter: Filter, settings: Settings, completion: @escaping (Result<[User], SoulSwiftError>) -> Void) {
        let queryParameters = [
            "anonymousUser": SoulSwiftClient.shared.soulConfiguration.anonymousUser,
            "apiKey": SoulSwiftClient.shared.soulConfiguration.apiKey
        ]
        let bodyParameters: [String: Any] = ["filter": filter, "settings": settings]
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulUsersEndpoint.recommendationsList,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.users })
        }
    }
}
