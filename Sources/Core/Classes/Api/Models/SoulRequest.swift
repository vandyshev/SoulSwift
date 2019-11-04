class SoulRequest {

    let baseURL: String
    let httpMethod: HTTPMethod
    let soulEndpoint: SoulEndpoint
    let needAuthorization: Bool
    var queryParameters: [String: String]?
    var body: Encodable?

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }

    func setQueryParameters(_ parameters: [String: Any?]) {
        self.queryParameters = parameters.compactMapValuesToString()
    }

    func setBodyParameters(_ parameters: [String: Any?]) {
        self.body = parameters.compactMapValuesToAnyEncodable()
    }

    init(baseURL: String = SoulClient.shared.soulConfiguration.baseURL,
         httpMethod: HTTPMethod = .GET,
         soulEndpoint: SoulEndpoint,
         queryParameters: [String: String]? = nil,
         body: Encodable? = nil,
         needAuthorization: Bool = false) {
        self.baseURL = baseURL
        self.httpMethod = httpMethod
        self.soulEndpoint = soulEndpoint
        self.queryParameters = queryParameters
        self.body = body
        self.needAuthorization = needAuthorization
    }
}

extension Dictionary where Key == String {
    func compactMapValuesToAnyEncodable() -> [Key: AnyEncodable] {
        return compactMapValues { value -> AnyEncodable? in
            if let encodable = value as? Encodable {
                return AnyEncodable(encodable)
            } else {
                return nil
            }
        }
    }

    func compactMapValuesToString() -> [Key: String] {
        return compactMapValues { value -> String? in
            switch value {
            case let value as String: return value
            case let value as Bool: return value ? "true" : "false"
            case let value as Int: return String(value)
            case let value as Float: return String(value)
            case let value as Double: return String(value)
            case let value as CustomStringConvertible: return value.description
            default: return nil
            }
        }
    }

}
