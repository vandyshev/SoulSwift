protocol SoulProviderProtocol: class {
    func request(_ soulRequest: SoulRequest, completion: @escaping (Result<SoulResponse, SoulSwiftError>) -> Void)
}

class SoulProvider: SoulProviderProtocol {

    private var session = URLSession(configuration: .default)
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let soulAuthorizationProvider: SoulAuthorizationProviderProtocol
    private let soulApiVersionProvider: SoulApiVersionProviderProtocol
    private let soulUserAgentProvider: SoulUserAgentProviderProtocol
    private let soulRefreshTokenProvider: SoulRefreshTokenProviderProtocol

    init(soulAuthorizationProvider: SoulAuthorizationProviderProtocol,
         soulVersionProvider: SoulApiVersionProviderProtocol,
         soulUserAgentVersionProvider: SoulUserAgentProviderProtocol,
         soulRefreshTokenProvider: SoulRefreshTokenProviderProtocol) {
        self.soulAuthorizationProvider = soulAuthorizationProvider
        self.soulApiVersionProvider = soulVersionProvider
        self.soulUserAgentProvider = soulUserAgentVersionProvider
        self.soulRefreshTokenProvider = soulRefreshTokenProvider
    }

    func request(_ soulRequest: SoulRequest, completion: @escaping (Result<SoulResponse, SoulSwiftError>) -> Void) {
        request(soulRequest, retryCount: 1, completion: completion)
    }

    func request(_ soulRequest: SoulRequest, retryCount: Int, completion: @escaping (Result<SoulResponse, SoulSwiftError>) -> Void) {
        guard let urlRequest = urlRequest(soulRequest: soulRequest) else {
            completion(.failure(SoulSwiftError.requestError))
            return
        }
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let sSelf = self else { return }
            if sSelf.soulRefreshTokenProvider.isNeedRefreshToken(for: response), retryCount > 0 {
                sSelf.soulRefreshTokenProvider.refreshToken(provider: sSelf) {
                    sSelf.request(soulRequest, retryCount: retryCount - 1, completion: completion)
                }
            } else {
                soulResponse(data, response, error)
            }
        }
        task.resume()

        func soulError(from data: Data?, and response: URLResponse?) -> SoulError? {
            guard let response = response as? HTTPURLResponse else { return nil }
            guard let data = data else { return nil }
            if (200...299).contains(response.statusCode) { return nil }
            return try? decoder.decode(SoulErrorResponse.self, from: data).error
        }

        func soulResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
            let result: Result<SoulResponse, SoulSwiftError>
            if let error = error {
                result = .failure(SoulSwiftError.networkError(error))
            } else if let error = soulError(from: data, and: response) {
                result = .failure(SoulSwiftError.apiError(error))
            } else if let data = data {
                do {
                    result = .success(try decoder.decode(SoulResponse.self, from: data))
                } catch {
                    result = .failure(SoulSwiftError.decoderError)
                }
            } else {
                result = .failure(SoulSwiftError.unknown)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func urlRequest(soulRequest: SoulRequest) -> URLRequest? {
        var components = URLComponents()
        components.path = soulRequest.soulEndpoint.path
        components.queryItems = soulRequest.queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        guard let baseURL = URL(string: SoulSwiftClient.shared.soulConfiguration.baseURL) else { return nil }
        guard let url = components.url(relativeTo: baseURL) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = soulRequest.httpMethod.rawValue

        if let body = soulRequest.body {
            let encodable = AnyEncodable(body)
            request.httpBody = try? encoder.encode(encodable)
            let contentTypeHeaderName = "Content-Type"
            if request.value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                request.setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
        }

        request = soulApiVersionProvider.addApiVersion(request)
        request = soulUserAgentProvider.addUserAgent(request)

        if soulRequest.needAuthorization {
            request = soulAuthorizationProvider.authorize(request)
        }
        return request
    }
}
