import Foundation

struct PasswordRegisterRequestParameters: Encodable {
    let login: String
    let password: String
    let apiKey: String
    let anonymousUser: String?
    let merge: Bool?
    let mergePreference: MergePreference?

    enum CodingKeys: String, CodingKey {
        case login
        case password = "passwd"
        case apiKey
        case anonymousUser
        case merge
        case mergePreference
    }
}
