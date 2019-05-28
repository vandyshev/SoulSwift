public struct SoulConfiguration {
    /// Soul Platform URL
    private(set) public var baseURL: String
    /// API key
    private(set) public var apiKey: String
    /// App name
    private(set) public var appName: String
    /// Chat URL string
    private(set) public var chatURL: String
    /// Chat Api Key
    private(set) public var chatApiKey: String

    public init(baseURL: String,
                apiKey: String,
                appName: String,
                chatURL: String,
                chatApiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.appName = appName
        self.chatURL = chatURL
        self.chatApiKey = chatApiKey
    }
}
