public struct Settings {
    let settings: [String: AnyEncodable]

    public init(settings: [String: AnyEncodable]) {
        self.settings = settings
    }
}
