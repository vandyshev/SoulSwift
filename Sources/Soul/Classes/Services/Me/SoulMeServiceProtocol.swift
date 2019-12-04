public protocol SoulMeServiceProtocol {
    var meUpdated: ((MyUser) -> Void)? { get set }
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

    var meUpdated: ((MyUser) -> Void)? {
        didSet {
            soulMeProvider.meUpdated = { [weak self] in self?.meUpdated?($0) }
        }
    }

    private var soulProvider: SoulProviderProtocol
    private var soulMeProvider: SoulMeProviderProtocol

    init(soulProvider: SoulProviderProtocol,
         soulMeProvider: SoulMeProviderProtocol) {
        self.soulProvider = soulProvider
        self.soulMeProvider = soulMeProvider
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
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }
}
