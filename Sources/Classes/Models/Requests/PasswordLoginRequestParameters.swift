struct PasswordLoginRequestParameters: Encodable {
    let login: String
    let password: String
    let apiKey: String
    let anonymousUser: String?
    let merge: Bool?
    let mergePreference: MergePreference?
}
