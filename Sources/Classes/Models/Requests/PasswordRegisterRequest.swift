import Foundation

struct PasswordRegisterRequestParameters: Encodable {
    let login: String
    let passwd: String
    let apiKey: String
    let anonymousUser: String?
    let merge: Bool?
    let mergePreference: MergePreference?
}
