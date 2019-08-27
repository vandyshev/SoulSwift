public protocol UserServiceProtocol {

    //GET: /users/{userId}
    func users(userId: String, completion: @escaping (Result<User, SoulSwiftError>) -> Void)

    //POST: /users/{userId}/reactions/sent/{reactionType}
    func usersReactionsSent(userId: String, reactionType: String, reaction: Reaction, completion: @escaping (Result<User, SoulSwiftError>) -> Void)
}

final class UserService: UserServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    //GET: /users/{userId}
    func users(userId: String, completion: @escaping (Result<User, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.usersUserId(userId: userId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.user })
        }
    }

    //POST: /users/{userId}/reactions/sent/{reactionType}
    func usersReactionsSent(userId: String, reactionType: String, reaction: Reaction, completion: @escaping (Result<User, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulUsersEndpoint.usersUserIdReactionsSent(userId: userId, reactionType: reactionType),
            body: reaction,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.user })
        }
    }
}
