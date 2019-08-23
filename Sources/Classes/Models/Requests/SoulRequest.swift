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
