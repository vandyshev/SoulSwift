import Foundation

private enum Constants {
    static let maxRetryCount = 3
}

public typealias SoulResult<T> = Result<T, SoulSwiftError>

public extension SoulResult {
    typealias Completion = (Self) -> Void
}

protocol SoulProviderProtocol: class {
    func request<Request: SoulRequest, Response: Decodable>(_ soulRequest: Request, completion: @escaping SoulResult<Response>.Completion)
    func request<Request: SoulRequest, Response: Decodable>(_ soulRequest: Request, retryCount: Int, completion: @escaping SoulResult<Response>.Completion)
}

// swiftlint:disable line_length
class SoulProvider: SoulProviderProtocol {

    private var session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()

    private let soulAuthorizationProvider: SoulAuthorizationProviderProtocol
    private let soulApiVersionProvider: SoulApiVersionProviderProtocol
    private let soulUserAgentProvider: SoulUserAgentProviderProtocol
    private let soulRefreshTokenProvider: SoulRefreshTokenProviderProtocol
    private let soulAdditionalInfoProvider: SoulAdditionalInfoProviderProtocol
    private let soulDateProvider: SoulDateProviderProtocol
    private let soulMeProvider: SoulMeProviderProtocol
    private let soulErrorProvider: SoulErrorProviderProtocol

    init(soulAuthorizationProvider: SoulAuthorizationProviderProtocol,
         soulVersionProvider: SoulApiVersionProviderProtocol,
         soulUserAgentVersionProvider: SoulUserAgentProviderProtocol,
         soulRefreshTokenProvider: SoulRefreshTokenProviderProtocol,
         soulAdditionalInfoProvider: SoulAdditionalInfoProviderProtocol,
         soulDateProvider: SoulDateProviderProtocol,
         soulMeProviderProtocol: SoulMeProviderProtocol,
         soulErrorProvider: SoulErrorProviderProtocol) {
        self.soulAuthorizationProvider = soulAuthorizationProvider
        self.soulApiVersionProvider = soulVersionProvider
        self.soulUserAgentProvider = soulUserAgentVersionProvider
        self.soulRefreshTokenProvider = soulRefreshTokenProvider
        self.soulAdditionalInfoProvider = soulAdditionalInfoProvider
        self.soulDateProvider = soulDateProvider
        self.soulMeProvider = soulMeProviderProtocol
        self.soulErrorProvider = soulErrorProvider
    }

    func request<Request: SoulRequest, Response: Decodable>(_ soulRequest: Request, completion: @escaping SoulResult<Response>.Completion) {
        request(soulRequest, retryCount: Constants.maxRetryCount, completion: completion)
    }

    func request<Request: SoulRequest, Response: Decodable>(_ soulRequest: Request, retryCount: Int, completion: @escaping SoulResult<Response>.Completion) {
        guard let urlRequest = urlRequest(soulRequest: soulRequest) else {
            let result: SoulResult<Response> = .failure(SoulSwiftError.requestError)
            soulErrorProvider.handleError(result)
            completion(result)
            return
        }
        print("Soul Request: \(soulRequest.debugDescription)")
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            print("Soul Response: \(soulRequest.debugDescription)")
            guard let sSelf = self else { return }
            if sSelf.soulRefreshTokenProvider.isNeedRefreshToken(for: response), retryCount > 0 {
                sSelf.soulRefreshTokenProvider.refreshToken(provider: sSelf) { result in
                    switch result {
                    case .success:
                        sSelf.request(soulRequest, retryCount: retryCount - 1, completion: completion)
                    case .failure:
                        sSelf.request(soulRequest, retryCount: 0, completion: completion)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let result: SoulResult<Response> = sSelf.soulResponse(data, response, error)
                    sSelf.soulAdditionalInfoProvider.saveAdditionalInfo(data)
                    sSelf.soulDateProvider.updateServerTimeDelta(data)
                    sSelf.soulMeProvider.updateMe(data)
                    sSelf.soulErrorProvider.handleError(result)
                    completion(result)
                }
            }
        }
        task.resume()
    }

    func refreshTokenRequest<Request: SoulRequest, Response: Decodable>(_ soulRequest: Request, completion: @escaping SoulResult<Response>.Completion) {
        guard let urlRequest = urlRequest(soulRequest: soulRequest) else {
            completion(.failure(SoulSwiftError.requestError))
            return
        }
        print("Soul Refresh Token Request: \(soulRequest.debugDescription)")
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            print("Soul Refresh Token Response: \(soulRequest.debugDescription)")
            guard let sSelf = self else { return }
            let result: SoulResult<Response> = sSelf.soulResponse(data, response, error)
            completion(result)
        }
        task.resume()
    }

    private func urlRequest(soulRequest: SoulRequest) -> URLRequest? {
        var components = URLComponents()
        components.path = soulRequest.soulEndpoint.path
        components.queryItems = soulRequest.queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        guard let baseURL = URL(string: soulRequest.baseURL) else { return nil }
        guard let url = components.url(relativeTo: baseURL) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = soulRequest.httpMethod.rawValue

        if let httpBody = soulRequest.httpBody {
            request.httpBody = httpBody
        }

        if let httpHeaderFields = soulRequest.httpHeaderFields {
            for (key, value) in httpHeaderFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
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
        return try? decoder.decode(SoulErrorResponse.self, from: data).error
    }

    private func soulResponse<Response: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> SoulResult<Response> {
        let result: Result<Response, SoulSwiftError>
        if let error = error {
            result = .failure(SoulSwiftError.networkError(error))
        } else if let error = soulError(from: data, and: response) {
            result = .failure(SoulSwiftError.soulError(error))
        } else if let data = data {
            do {
                result = .success(try decoder.decode(Response.self, from: data))
            } catch {
                result = .failure(SoulSwiftError.decoderError)
            }
        } else {
            result = .failure(SoulSwiftError.unknown)
        }
        return result
    }
}
