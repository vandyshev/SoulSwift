struct AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

struct SoulRequest {

    let httpMethod: HTTPMethod
    let soulEndpoint: SoulEndpoint
    let queryParameters: [String: Any?]?
    let bodyParameters: [String: Any]?
    let needAuthorization: Bool

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }

    init(httpMethod: HTTPMethod = .GET,
         soulEndpoint: SoulEndpoint,
         queryParameters: [String: Any?]? = nil,
         bodyParameters: [String: Any]? = nil,
         needAuthorization: Bool = false) {
        self.httpMethod = httpMethod
        self.soulEndpoint = soulEndpoint
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.needAuthorization = needAuthorization
    }

    init(httpMethod: HTTPMethod = .GET,
         soulEndpoint: SoulEndpoint,
         queryParameters: [String: Any?]? = nil,
         body: Encodable,
         needAuthorization: Bool = false) {
        self.httpMethod = httpMethod
        self.soulEndpoint = soulEndpoint
        self.queryParameters = queryParameters
        self.bodyParameters = body.dictionary
        self.needAuthorization = needAuthorization
    }

    // TODO: Если вывод типов будет занимать много времени, то сделать явное приведение типов
    var queryItems: [URLQueryItem]? {
        return queryParameters?.compactMapValues { $0 }
            .compactMapValues {
                switch $0 {
                case let stringValue as String:
                    return stringValue
                case let stringConvertibleValue as CustomStringConvertible:
                    return stringConvertibleValue.description
                default:
                    // TODO: Сделать логирование
                    print("Error: queryParameter: \($0) can't converte to String")
                    return nil
                }
            }
            .map { URLQueryItem(name: $0, value: $1) }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
