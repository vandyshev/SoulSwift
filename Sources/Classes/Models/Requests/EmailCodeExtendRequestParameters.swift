struct EmailCodeExtendRequestParameters: Encodable {
    let email: String
    let apiKey: String
    let code: String
    let lastSessionToken: String
}
