import UIKit

/// generates uri for ChatClient
protocol ChatClientURIFactory {
    var wsConnectionURI: URL? { get }
}

protocol ChatApiURLFactory {
    var httpUrlWithApiKey: String { get }
    var chatAuthMethod: String { get }
    var chatAuthEndpoint: String { get }
}

struct ChatURIFactoryConfig {
    // should be declared without scheme, but with port and with last `/` character
    let baseUrlString: String
    let apiKey: String

    public init(baseUrlString: String, apiKey: String) {
        self.baseUrlString = baseUrlString
        self.apiKey        = apiKey
    }
}

private enum Constants {
    static let wsScheme = "wss://"
    static let httpScheme = "https://"
    static let wsAuthMethod = "GET"
    static let wsAuthEndpoint = "/me"
    static let apiVersion = "/v1"
    static let wsPart = "/ws"
    static let allowedCharactersSet = CharacterSet(charactersIn: " ;").inverted
    static let authQueryItemName = "auth"
    static let userAgentQueryItemName = "user-agent"
    static let deviceIDQueryItemName = "device-id"
}

final class ChatClientURIFactoryImpl: ChatClientURIFactory, ChatApiURLFactory {

    private let config: ChatURIFactoryConfig
    private let authHelper: AuthHelper
    private let deviceHandler: DeviceHandler

    var httpUrlWithApiKey: String { return buildBaseUrl(withScheme: Constants.httpScheme) }
    var wsConnectionURI: URL? { return buildWSURI() }
    var chatAuthMethod: String { return Constants.wsAuthMethod }
    var chatAuthEndpoint: String { return Constants.wsAuthEndpoint }

    init(config: ChatURIFactoryConfig, authHelper: AuthHelper, deviceHandler: DeviceHandler) {
        self.authHelper = authHelper
        self.config = config
        self.deviceHandler = deviceHandler
    }

    private func buildWSURI() -> URL? {
        let authConfig = AuthConfig(endpoint: Constants.wsAuthEndpoint,
                                    method: Constants.wsAuthMethod,
                                    body: "")
        let generatedAuth = authHelper.authString(withAuthConfig: authConfig)

        guard let userAuth = generatedAuth,
            let auth = addingPercentEncoding(userAuth),
            let userAgent = addingPercentEncoding(authHelper.userAgent),
            let deviceID = addingPercentEncoding(deviceHandler.deviceIdentifier) else {
                assertionFailure()
                return nil
        }

        let urlString = buildBaseUrl(withScheme: Constants.wsScheme) + Constants.wsPart

        // can't use URLQueryItem because of percentage encoding of `;` symbol
        let wsUri = urlString
            + "?auth=" + auth
            + "&user-agent=" + userAgent
            + "&device-id=" + deviceID

        return URL(string: wsUri)
    }

    private func buildBaseUrl(withScheme scheme: String) -> String {
        return scheme + config.baseUrlString + config.apiKey + Constants.apiVersion
    }

    private func addingPercentEncoding(_ target: String) -> String? {
        return target.addingPercentEncoding(withAllowedCharacters: Constants.allowedCharactersSet)
    }
}

extension DreamConfiguration {
    var chatURIFactoryConfig: ChatURIFactoryConfig {
        return ChatURIFactoryConfig(baseUrlString: chatHttpURL, apiKey: chatApiKey)
    }
}
