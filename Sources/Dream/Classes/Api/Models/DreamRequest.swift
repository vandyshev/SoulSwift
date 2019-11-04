class DreamRequest: SoulRequest {
    override init(baseURL: String = DreamClient.shared.dreamConfiguration.chatHttpURL,
                  httpMethod: SoulRequest.HTTPMethod = .GET,
                  soulEndpoint: SoulEndpoint,
                  queryParameters: [String: String]? = nil,
                  body: Encodable? = nil,
                  needAuthorization: Bool = false) {
        super.init(
            baseURL: baseURL,
            httpMethod: httpMethod,
            soulEndpoint: soulEndpoint,
            queryParameters: queryParameters,
            body: body,
            needAuthorization: needAuthorization
        )
    }
}
