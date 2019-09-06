// swiftlint:disable line_length
protocol DreamProviderProtocol {
    func request<Request: DreamRequest, Response: Decodable>(_ dreamRequest: Request, completion: @escaping (Result<Response, SoulSwiftError>) -> Void)
}

class DreamProvider: SoulProvider, DreamProviderProtocol {}

//extension DreamProvider: DreamProviderProtocol {
//    func request(_ dreamRequest: DreamRequest, completion: @escaping (Result<DreamResponse, SoulSwiftError>) -> Void) {
//        super.request(dreamRequest, completion: completion)
//    }
//}
