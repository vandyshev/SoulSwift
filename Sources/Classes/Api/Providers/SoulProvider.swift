protocol SoulProviderProtocol {
    func request<D: Decodable>(_ request: SoulRequest, completion: @escaping (Result<D, SoulSwiftError>) -> Void)
}

class SoulProvider: SoulProviderProtocol {

    private let session: URLSession = URLSession(configuration: .default)
    private let soulAuthorizationProvider: SoulAuthorizationProviderProtocol
    private let soulApiVersionProvider: SoulApiVersionProviderProtocol
    private let soulUserAgentProvider: SoulUserAgentProviderProtocol

    init(soulAuthorizationProvider: SoulAuthorizationProviderProtocol,
         soulVersionProvider: SoulApiVersionProviderProtocol,
         soulUserAgentVersionProvider: SoulUserAgentProviderProtocol) {
        self.soulAuthorizationProvider = soulAuthorizationProvider
        self.soulApiVersionProvider = soulVersionProvider
        self.soulUserAgentProvider = soulUserAgentVersionProvider
    }

    func request<D: Decodable>(_ request: SoulRequest, completion: @escaping (Result<D, SoulSwiftError>) -> Void) {
        guard let request = urlRequest(soulRequest: request) else {
            completion(.failure(SoulSwiftError.requestError))
            return
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            let result: Result<D, SoulSwiftError>
            if let error = error {
                result = .failure(SoulSwiftError.underlying(error))
            } else if let error = self.soulError(from: data, and: response) {
                result = .failure(SoulSwiftError.apiError(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    result = .success(try decoder.decode(D.self, from: data))
                } catch {
                    result = .failure(SoulSwiftError.underlying(error))
                }
            } else {
                result = .failure(SoulSwiftError.unknown)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }

    private func urlRequest(soulRequest: SoulRequest) -> URLRequest? {
        guard var components = URLComponents(string: SoulSwiftClient.shared.soulConfiguration.baseURL) else {
            return nil
        }
        components.path = soulRequest.soulEndpoint.path
        components.queryItems = soulRequest.queryItems
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = soulRequest.httpMethod.rawValue
        if let parameters = soulRequest.bodyParameters {
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
        }

        request = soulApiVersionProvider.addApiVersion(request)
        request = soulUserAgentProvider.addUserAgent(request)

        if soulRequest.needAuthorization {
            request = soulAuthorizationProvider.authorize(request)
        }
        return request
    }

    private func soulError(from data: Data?, and response: URLResponse?) -> SoulError? {
        guard let response = response as? HTTPURLResponse else { return nil }
        guard let data = data else { return nil }
        if (200...299).contains(response.statusCode) { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(SoulErrorResponse.self, from: data).error
    }

}
