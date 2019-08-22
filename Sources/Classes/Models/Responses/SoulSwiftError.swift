public enum SoulSwiftError: Swift.Error {
    case requestError
    case apiError(SoulApiError)
    case underlying(Swift.Error)
    case unknown
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
