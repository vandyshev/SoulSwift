import Foundation

public enum SoulSwiftError: Swift.Error {
    case requestError
    case decoderError
    case refreshToken
    case soulError(HTTPURLResponse, SoulError)
    case networkError(Swift.Error)
    case unknown
}

struct SoulErrorResponse: Codable {
    let error: SoulError
}

public struct SoulError: Swift.Error {
    public let alias: String
    public let code: Int
    public let userMessage: String
    public let developerMessage: String
}

extension SoulError: Codable {}
