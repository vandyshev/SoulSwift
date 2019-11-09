public protocol SoulContactsServiceProtocol {
    func sendContactRequest(to userId: String, completion: @escaping (Result<[ContactRequest], SoulSwiftError>) -> Void)
    func cancelContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion)
    func approveContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion)
    func declineContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion)
    func changeContactName(_ userId: String, newName: String, completion: @escaping SoulResult<Void>.Completion)
    func deleteContact(userId: String, completion: @escaping SoulResult<Void>.Completion)
    func getLastSentRequest(chatId: String, completion: @escaping (Result<ContactRequest?, SoulSwiftError>) -> Void)
}

final class SoulContactsService: SoulContactsServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func sendContactRequest(to userId: String, completion: @escaping (Result<[ContactRequest], SoulSwiftError>) -> Void) {}
    func cancelContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion) {}
    func approveContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion) {}
    func declineContactRequest(_ userId: String, completion: @escaping SoulResult<Void>.Completion) {}
    func changeContactName(_ userId: String, newName: String, completion: @escaping SoulResult<Void>.Completion) {}
    func deleteContact(userId: String, completion: @escaping SoulResult<Void>.Completion) {}
    func getLastSentRequest(chatId: String, completion: @escaping (Result<ContactRequest?, SoulSwiftError>) -> Void) {}
}
