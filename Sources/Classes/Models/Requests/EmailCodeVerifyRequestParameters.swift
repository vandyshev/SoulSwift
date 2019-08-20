
struct EmailCodeVerifyRequestParameters: Encodable {
    let email: String
    let apiKey: String
    let code: String
    let merge: Bool?
    let mergePreference: MergePreference?
}
