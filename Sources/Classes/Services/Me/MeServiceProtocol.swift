public protocol MeServiceProtocol {
    // GET: /me
    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setParameters(parameters: MeParameters, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // DELETE: /me
    func deleteMe(completion: @escaping (Result<Void, SoulSwiftError>) -> Void)
}

final class MeService: MeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.me,
            bodyParameters: nil,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            bodyParameters: ["notificationTokens": ["APNS": apnsToken]],
            needAuthorization: true
        )
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
            bodyParameters: nil,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }
}
