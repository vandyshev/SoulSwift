import Foundation

public enum SoulSwiftError: Swift.Error {
    case requestError
    case decoderError(DecodingError?)
    case transformError(TransformError)
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

public struct TransformError: Swift.Error {
    public let from: String
    public let to: String

    public init(from: Any, to: Any...) {
        self.from = String(describing: type(of: from))
        self.to = to.map { String(describing: type(of: $0)) }.joined(separator: ", ")
    }
}
