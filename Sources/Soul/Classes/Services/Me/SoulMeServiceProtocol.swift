public protocol SoulMeServiceProtocol {
    // GET: /me
    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setParameters(parameters: MeParameters, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // DELETE: /me
    func deleteMe(completion: @escaping (Result<Void, SoulSwiftError>) -> Void)
}

final class SoulMeService: SoulMeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.me,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            needAuthorization: true
        )
        request.setBodyParameters(["notificationTokens": ["APNS": apnsToken]])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setParameters(parameters: MeParameters, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            body: parameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func deleteMe(completion: @escaping (Result<Void, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .DELETE,
            soulEndpoint: SoulMeEndpoint.me,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }
}
