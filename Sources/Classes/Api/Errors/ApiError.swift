import Foundation
import Moya

public enum ApiError {
    case mappingError(description: String)
    case invalidStatusCode(code: Int)
    case networkConnection(code: Int, domain: String)
    case badRequest
    case unknown(error: Error)
    case chatSocketError(Error)
}

extension ApiError: Error {
    init(moyaError: MoyaError) {
        switch moyaError {
        case .imageMapping(let response),
             .jsonMapping(let response),
             .stringMapping(let response),
             .objectMapping(_, let response):
            self = .mappingError(description: moyaError.errorDescription ?? response.description)
        case .statusCode(let response):
            self = .invalidStatusCode(code: response.statusCode)
        case .encodableMapping(let error):
            self = .unknown(error: error)
        case .underlying(let nsError as NSError, let response):
            // now can access NSError error.code or whatever
            // e.g. NSURLErrorTimedOut or NSURLErrorNotConnectedToInternet
            self = .networkConnection(code: nsError.code, domain: nsError.domain)
        case .underlying(let error, _):
            self = .unknown(error: error)
        case .requestMapping, .parameterEncoding:
            self = .badRequest
        }
    }
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .mappingError(description: description):
            return description
        case let .invalidStatusCode(code: code):
            return "Failed with http status code: \(code)"
        case let .networkConnection(code: code, domain: domain):
            return "Network connection error. Code: \(code), domain: \(domain)"
        case .badRequest:
            return "Failed to create URLRequest"
        case let .unknown(error: error):
            return error.localizedDescription
        case let .chatSocketError(error):
            return "Socket Error: \(error.localizedDescription)"
        }
    }
}
