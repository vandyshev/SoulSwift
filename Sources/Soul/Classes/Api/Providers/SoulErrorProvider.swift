protocol SoulErrorProviderProtocol {
    var errorCompletion: ((SoulSwiftError) -> Void)? { get set}
    func handleError<Response: Decodable>(_ result: SoulResult<Response>)
}

class SoulErrorProvider: SoulErrorProviderProtocol {
    var errorCompletion: ((SoulSwiftError) -> Void)?

    func handleError<Response: Decodable>(_ result: SoulResult<Response>) {
        if case .failure(let error) = result {
            errorCompletion?(error)
        }
    }
}
