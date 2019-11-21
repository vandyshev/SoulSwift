public struct Filter: Encodable {
    let filter: [String: AnyEncodable]

    public init(filter: [String: AnyEncodable]) {
        self.filter = filter
    }
}
