public protocol SoulUserServiceProtocol {

    // GET: /users/{userId}
    func users(userId: String, completion: @escaping SoulResult<User>.Completion)

    // POST: /users/{userId}/reactions/sent/{reactionType}
    func usersReactionsSent(userId: String, reactionType: String, reactionParameters: ReactionParameters, completion: @escaping SoulResult<(User, [Event])>.Completion)

    // POST: /users/{userId}/flag
    func usersFlag(userId: String, reason: String, comment: String?, screen: String?, completion: @escaping SoulResult<Void>.Completion)

    // GET: /users/{userId}/albums/{albumName}/{photoId}
    func photo(userId: String, albumName: String, photoId: String, completion: @escaping SoulResult<Photo>.Completion)
}

final class SoulUserService: SoulUserServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    //GET: /users/{userId}
    func users(userId: String, completion: @escaping SoulResult<User>.Completion) {
        let request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.usersUserId(userId: userId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.user })
        }
    }

    //POST: /users/{userId}/reactions/sent/{reactionType}
    func usersReactionsSent(userId: String, reactionType: String, reactionParameters: ReactionParameters, completion: @escaping SoulResult<(User, [Event])>.Completion) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulUsersEndpoint.usersUserIdReactionsSent(userId: userId, reactionType: reactionType),
            body: reactionParameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.user, $0.events) })
        }
    }

    func usersFlag(userId: String, reason: String, comment: String?, screen: String?, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulUsersEndpoint.usersUserIdFlag(userId: userId),
            needAuthorization: true
        )
        request.setBodyParameters(["reason": reason,
                                   "comment": comment,
                                   "screen": screen])
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    // GET: /users/{userId}/albums/{albumName}/{photoId}
    func photo(userId: String, albumName: String, photoId: String, completion: @escaping SoulResult<Photo>.Completion) {
        let request = SoulRequest(
            soulEndpoint: SoulUsersEndpoint.usersUserIdAlbumsAlbumNamePhotoId(userId: userId, albumName: albumName, photoId: photoId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.photo })
        }
    }
}
