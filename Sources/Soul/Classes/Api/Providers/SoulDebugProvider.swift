import Foundation

protocol SoulDebugProviderProtocol {

    func debug(_ request: URLRequest)
    func debug<Response: Decodable>(_ request: URLRequest, _ data: Data?, _ result: SoulResult<Response>)
}

class SoulDebugProvider: SoulDebugProviderProtocol {

    func debug(_ request: URLRequest) {
        let httpBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        print("\n===>\n[SoulSwift] Request:\n\(request.url?.absoluteString ?? "")\n\(httpBody)\n<===\n")
    }

    func debug<Response: Decodable>(_ request: URLRequest, _ data: Data?, _ result: SoulResult<Response>) {
        let requestBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        print("\n===>\n[SoulSwift] Request:\n\(request.url?.absoluteString ?? "")\n\(requestBody)\n\n[SoulSwift] Response:\n\(responseBody)\n\n[SoulSwift] Result:\n\(result)\n<===\n")

    }

}
