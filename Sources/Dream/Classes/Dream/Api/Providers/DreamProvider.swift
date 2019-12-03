// swiftlint:disable line_length
protocol DreamProviderProtocol {
    func request<Request: DreamRequest, Response: Decodable>(_ dreamRequest: Request, completion: @escaping (Result<Response, SoulSwiftError>) -> Void)
}

class DreamProvider: SoulProvider, DreamProviderProtocol {}
