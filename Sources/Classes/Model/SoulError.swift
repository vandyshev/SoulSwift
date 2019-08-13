import Foundation

struct SoulErrorResponse: Codable {
    let error: SoulError
}

struct SoulError: Codable {
    let alias: String
    let code: Int
    let userMessage: String
    let developerMessage: String
}
