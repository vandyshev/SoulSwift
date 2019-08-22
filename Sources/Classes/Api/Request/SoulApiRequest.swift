struct SoulApiRequest {

    let httpMethod: HTTPMethod
    let soulApiEndpoint: SoulApiEndpoint
    let queryItems: [String: String]?
    let bodyParameters: [String: Any]?
    let needAuthorization: Bool

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }
}
