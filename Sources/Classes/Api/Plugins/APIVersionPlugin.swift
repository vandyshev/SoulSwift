import Foundation
import Moya

protocol APIVersionTargetType: TargetType {
    var needsAPIVersion: Bool { get }
}

struct APIVersionPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? APIVersionTargetType, target.needsAPIVersion else { return request }
        var request = request
        if let url = request.url, var urlComponents = URLComponents(string: url.absoluteString) {
            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: "v", value: SoulSwiftClient.shared.soulConfiguration.apiVersion))
            urlComponents.queryItems = queryItems
            request.url = urlComponents.url
        }
        return request
    }
}
