import Foundation

struct PhoneVerifyRequestParameters: Encodable {
    let phoneNumber: String
    let apiKey: String
    let code: String
    let merge: Bool?
    let mergePreference: MergePreference?
}
