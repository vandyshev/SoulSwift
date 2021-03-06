protocol SoulApiVersionProviderProtocol {
    func addApiVersion(_ request: URLRequest) -> URLRequest
}

class SoulVersionProvider: SoulApiVersionProviderProtocol {

    func addApiVersion(_ request: URLRequest) -> URLRequest {
        var request = request
        if let url = request.url, var urlComponents = URLComponents(string: url.absoluteString) {
            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: "v", value: SoulClient.shared.soulConfiguration.apiVersion))
            urlComponents.queryItems = queryItems
            request.url = urlComponents.url
        }
        return request
    }
}
