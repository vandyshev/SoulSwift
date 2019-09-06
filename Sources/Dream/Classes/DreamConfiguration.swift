public struct DreamConfiguration {
    /// Chat HTTP URL string
    private(set) public var chatHttpURL: String
    /// Chat WebSocket URL string
    private(set) public var chatWsURL: String
    /// Chat API key
    private(set) public var chatApiKey: String
    /// Chat API version
    private(set) public var chatApiVersion: String

    public init(chatHttpURL: String,
                chatWsURL: String,
                chatApiKey: String,
                chatApiVersion: String) {
        self.chatHttpURL = chatHttpURL
        self.chatWsURL = chatWsURL
        self.chatApiKey = chatApiKey
        self.chatApiVersion = chatApiVersion
    }
}
