public protocol SoulMeServiceProtocol {
    // GET: /me
    func me(completion: @escaping SoulResult<MyUser>.Completion)
     // PATCH: /me
    func setNotificationToken(apnsToken: String, completion: @escaping SoulResult<MyUser>.Completion)
     // PATCH: /me
    func setParameters(parameters: MyUserParameters, completion: @escaping SoulResult<MyUser>.Completion)
    // DELETE: /me
    func deleteMe(completion: @escaping SoulResult<Void>.Completion)
}

final class SoulMeService: SoulMeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func me(completion: @escaping SoulResult<MyUser>.Completion) {
        var request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.me,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setNotificationToken(apnsToken: String, completion: @escaping SoulResult<MyUser>.Completion) {
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

    func setParameters(parameters: MyUserParameters, completion: @escaping SoulResult<MyUser>.Completion) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            body: ["parameters": parameters],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func deleteMe(completion: @escaping SoulResult<Void>.Completion) {
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
