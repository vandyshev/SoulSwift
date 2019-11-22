class SoulRequest {

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }

    private(set) var baseURL: String
    private(set) var httpMethod: HTTPMethod
    private(set) var soulEndpoint: SoulEndpoint
    private(set) var needAuthorization: Bool
    private(set) var queryParameters: [String: String]?
    private(set) var httpBody: Data?
    private(set) var httpHeaderFields: [String: String]?

    private let encoder = JSONEncoder()
    private lazy var boundary: String = {
       return String(format: "%08X%08X", arc4random(), arc4random())
    }()

    func setQueryParameters(_ parameters: [String: Any?]) {
        self.queryParameters = parameters.compactMapValuesToString()
    }

    func setBodyParameters(_ parameters: [String: Any?]) {
        setBodyEncodable(parameters.compactMapValuesToAnyEncodable())
    }

    func setBodyEncodable(_ body: Encodable?) {
        guard let body = body else { return }
        httpBody = try? encoder.encode(AnyEncodable(body))
        httpHeaderFields = ["Content-Type": "application/json"]
    }

    func setUploads(file: Data, name: String, fileName: String, mimeType: String) {
        var httpBody = Data()
        httpBody.append(Data("--\(boundary)\r\n".utf8))
        httpBody.append(Data("Content-Disposition: form-data; name=\"\(name)\";filename=\"\(fileName)\"\r\n".utf8))
        httpBody.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        httpBody.append(file)
        httpBody.append(Data("\r\n".utf8))
        httpBody.append(Data("--\(boundary)--\r\n".utf8))
        self.httpBody = httpBody
        httpHeaderFields = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
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
        self.needAuthorization = needAuthorization
        setBodyEncodable(body)
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
