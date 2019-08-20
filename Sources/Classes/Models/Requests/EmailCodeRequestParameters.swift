import Foundation

struct EmailCodeRequestParameters: Encodable {
    let email: String
    let apiKey: String
    let anonymousUser: String?
}
