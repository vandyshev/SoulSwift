public struct SoulConfiguration {
    /// Soul Platform URL
    public var baseURL: String
    /// API key
    public var apiKey: String
    /// App nam
    public var appName: String
//    /// PubNub publisher key
//    let pubKey: String?
//    /// PubNub subscriber key
//    let subKey: String?
//    /// PubNub cipher salt
//    let cipherSalt: String?
    public init(baseURL: String, apiKey: String, appName: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.appName = appName
    }
}
