public struct DreamConfiguration {
    /// Soul app name
    private(set) public var appName: String
    /// Chat HTTP URL string
    private(set) public var chatHttpURL: String
    /// Chat WebSocket URL string
    private(set) public var chatWsURL: String

    @available(*, deprecated, message: "Split to chatHttpURL and chatWsURL")
    private(set) public var chatURL: String

    /// Chat API key
    private(set) public var chatApiKey: String
    /// Chat API version
    private(set) public var chatApiVersion: String
    /// Chat WS Part
    private(set) public var chatWsPart: String

    public init(appName: String,
                chatHttpURL: String,
                chatWsURL: String,
                chatURL: String,
                chatApiKey: String,
                chatApiVersion: String = "v1",
                chatWsPart: String = "ws") {
        self.appName = appName
        self.chatHttpURL = chatHttpURL
        self.chatWsURL = chatWsURL
        self.chatURL = chatURL
        self.chatApiKey = chatApiKey
        self.chatApiVersion = chatApiVersion
        self.chatWsPart = chatWsPart
    }
}
