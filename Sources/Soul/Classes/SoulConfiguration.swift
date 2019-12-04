public struct SoulConfiguration {
    /// Soul Platform URL
    private(set) public var baseURL: String
    /// Soul API key
    private(set) public var apiKey: String
    /// Soul API version
    private(set) public var apiVersion: String
    /// Soul anonymous user id
    private(set) public var anonymousUser: String
    /// Soul app name
    private(set) public var appName: String

    private(set) public var debug: Bool

    public init(baseURL: String,
                apiKey: String,
                apiVersion: String = "1.0.1",
                anonymousUser: String = UUID().uuidString,
                appName: String,
                debug: Bool = false) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.apiVersion = apiVersion
        self.anonymousUser = anonymousUser
        self.appName = appName
        self.debug = debug
    }
}
