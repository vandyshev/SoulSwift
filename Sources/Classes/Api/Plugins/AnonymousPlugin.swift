import Foundation
import Moya

protocol AnonymousTargetType: TargetType {
    var needsAnonymous: Bool { get }
}

struct AnonymousPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let url = request.url, var urlComponents = URLComponents(string: url.absoluteString) {
            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: "anonymousUser", value: SoulSwiftClient.shared.soulConfiguration.anonymousUser))
            queryItems.append(URLQueryItem(name: "apiKey", value: SoulSwiftClient.shared.soulConfiguration.apiKey))
            urlComponents.queryItems = queryItems
            request.url = urlComponents.url
        }
        return request
    }
}
