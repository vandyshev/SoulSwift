import Foundation
import Moya

protocol AnonymousTargetType: TargetType {
    var needsAnonymous: Bool { get }
}

struct AnonymousPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let url = request.url, let urlComponents = URLComponents(string: url.absoluteString) {
            var urlComponents = urlComponents
            urlComponents.queryItems?.append(URLQueryItem(name: "anonymousUser", value: SoulSwiftClient.shared.soulConfiguration.anonymousUser))
            urlComponents.queryItems?.append(URLQueryItem(name: "apiKey", value: SoulSwiftClient.shared.soulConfiguration.apiKey))
            request.url = urlComponents.url
        }
        return request
    }
}
