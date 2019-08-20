import Foundation

struct PhoneRequestParameters: Encodable {
    let phoneNumber: String
    let method: PhoneRequestMethod
    let apiKey: String
    let anonymousUser: String?
}
