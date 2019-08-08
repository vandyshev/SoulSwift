import Foundation
import Moya

protocol APIVersionTargetType: TargetType {
    var needsAPIVersion: Bool { get }
}

struct APIVersionPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let url = request.url, let urlComponents = URLComponents(string: url.absoluteString) {
            var urlComponents = urlComponents
            urlComponents.queryItems?.append(URLQueryItem(name: "v", value: SoulSwiftClient.shared.soulConfiguration.apiVersion))
            request.url = urlComponents.url
        }
        return request
    }
}
