import Foundation

struct PhoneLoginRequestParameters: Encodable {
    let phoneNumber: String
    let apiKey: String
    let code: String
    let lastSessionToken: String
}
