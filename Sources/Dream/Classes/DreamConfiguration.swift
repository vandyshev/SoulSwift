public struct DreamConfiguration {
    /// Soul app name
    private(set) public var appName: String
    /// Chat HTTP URL string
    private(set) public var chatHttpURL: String
    /// Chat WebSocket URL string
    private(set) public var chatWsURL: String
    /// Chat API key
    private(set) public var chatApiKey: String
    /// Chat API version
    private(set) public var chatApiVersion: String

    public init(appName: String,
                chatHttpURL: String,
                chatWsURL: String,
                chatApiKey: String,
                chatApiVersion: String) {
        self.appName = appName
        self.chatHttpURL = chatHttpURL
        self.chatWsURL = chatWsURL
        self.chatApiKey = chatApiKey
        self.chatApiVersion = chatApiVersion
    }
}
