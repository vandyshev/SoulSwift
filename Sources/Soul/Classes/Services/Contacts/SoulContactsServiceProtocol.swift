public protocol SoulContactsServiceProtocol {
    // POST: /contacts/requests
    func sendContactRequest(userId: String, completion: @escaping SoulResult<ContactRequest>.Completion)
    // POST: /contacts/requests/{requestId}/cancel
    func cancelContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion)
    // POST: /contacts/requests/{requestId}/approve
    func approveContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion)
    // POST: /contacts/requests/{requestId}/decline
    func declineContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion)
    // PATCH /contacts/{userId}
    func editContactName(userId: String, nickname: String, completion: @escaping SoulResult<Void>.Completion)
    // DELETE: /contacts/{userId}
    func deleteContact(userId: String, completion: @escaping SoulResult<Void>.Completion)
    // GET: /contacts/requests/last_sent/{chat_id}
    func lastSentRequest(chatId: String, completion: @escaping SoulResult<ContactRequest?>.Completion)
}

final class SoulContactsService: SoulContactsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func sendContactRequest(userId: String, completion: @escaping SoulResult<ContactRequest>.Completion) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulContactsEndpoint.sendContactRequest,
            needAuthorization: true
        )
        request.setBodyParameters(["userId": userId])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.request })
        }
    }

    func cancelContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulContactsEndpoint.cancelContactRequest(requestId: requestId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func approveContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulContactsEndpoint.approveContactRequest(requestId: requestId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func declineContactRequest(requestId: String, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulContactsEndpoint.declineContactRequest(requestId: requestId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func editContactName(userId: String, nickname: String, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulContactsEndpoint.editContactName(userId: userId),
            needAuthorization: true
        )
        request.setBodyParameters(["nickname": nickname])
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func deleteContact(userId: String, completion: @escaping SoulResult<Void>.Completion) {
        var request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulContactsEndpoint.deleteContact(userId: userId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<EmptyResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func lastSentRequest(chatId: String, completion: @escaping SoulResult<ContactRequest?>.Completion) {
        var request = SoulRequest(
            httpMethod: .GET,
            soulEndpoint: SoulContactsEndpoint.lastSentRequest(chatId: chatId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.request })
        }
    }
}
