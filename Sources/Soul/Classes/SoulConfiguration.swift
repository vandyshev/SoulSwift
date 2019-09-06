public struct SoulConfiguration {
    /// Soul Platform URL
    private(set) public var baseURL: String
    /// API key
    private(set) public var apiKey: String
    /// API version
    private(set) public var apiVersion: String
    /// Anonymous user id
    private(set) public var anonymousUser: String
    /// App name
    private(set) public var appName: String
    /// Chat URL string
    private(set) public var chatURL: String
    /// Chat Api Key
    private(set) public var chatApiKey: String

    public init(baseURL: String,
                apiKey: String,
                apiVersion: String = "1.0.1",
                anonymousUser: String = UUID().uuidString,
                appName: String,
                chatURL: String,
                chatApiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.apiVersion = apiVersion
        self.anonymousUser = anonymousUser
        self.appName = appName
        self.chatURL = chatURL
        self.chatApiKey = chatApiKey
    }
}
