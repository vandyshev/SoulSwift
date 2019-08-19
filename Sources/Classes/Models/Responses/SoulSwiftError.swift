import Foundation
import Moya

public typealias SoulMoyaError = MoyaError

public enum SoulSwiftError: Swift.Error {
    case apiError(SoulApiError)
    case moyaError(SoulMoyaError)
    case underlying(Swift.Error)
}

struct SoulApiErrorResponse: Codable {
    let error: SoulApiError
}

public struct SoulApiError: Swift.Error {
    public let alias: String
    public let code: Int
    public let userMessage: String
    public let developerMessage: String
}

extension SoulApiError: Codable {}
