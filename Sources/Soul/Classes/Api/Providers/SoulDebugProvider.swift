import Foundation
import os

protocol SoulDebugProviderProtocol {

    func debug(_ request: URLRequest)
    func debug<Response: Decodable>(_ request: URLRequest, _ data: Data?, _ result: SoulResult<Response>)
}

class SoulDebugProvider: SoulDebugProviderProtocol {

    private let log = OSLog(subsystem: "SoulSwift", category: "network")

    private var isDebug: Bool {
        return SoulClient.shared.soulConfiguration.debug
    }

    func debug(_ request: URLRequest) {
        guard isDebug else { return }
        let url = request.url?.absoluteString ?? ""
        let httpBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        os_log("[SoulSwift] Request:\n%@\n%@", log: log, url, httpBody)
    }

    func debug<Response: Decodable>(_ request: URLRequest, _ data: Data?, _ result: SoulResult<Response>) {
        guard isDebug else { return }
        let url = request.url?.absoluteString ?? ""
        let requestBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        var string = String()
        Swift.dump(result, to: &string)
        os_log("[SoulSwift] Response:\n%@\n\n[SoulSwift] Request:\n%@\n%@\n\n[SoulSwift] Result:\n%@\n", log: log, url, requestBody, responseBody, string)
    }
}
