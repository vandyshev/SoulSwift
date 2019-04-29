import UIKit

/// generates uri for ChatClient
protocol ChatClientURIGenerator {
    var wsConnectionURI: URL? { get }
    var urlWithApiKey: String { get }
    var chatAuthMethod: String { get }
    var chatAuthEndpoint: String { get }
}

struct ChatURIGeneratorConfig {
    // should be declared with scheme, with port and with last `/` character
    let baseUrlString: String
    let apiKey: String

    public init(baseUrlString: String, apiKey: String) {
        self.baseUrlString = baseUrlString
        self.apiKey = apiKey
    }
}

final class ChatClientURIGeneratorImpl: ChatClientURIGenerator {

    private enum Constants {
        static let wsAuthMethod = "GET"
        static let wsAuthEndpoint = "/me"
        static let apiVersion = "/v1"
        static let wsPart = "/ws"
        static let allowedCharactersSet = CharacterSet(charactersIn: " ;").inverted
    }

    private let config: ChatURIGeneratorConfig
    private let authHelper: AuthHelper
    private let deviceHandler: DeviceHandler

    var urlWithApiKey: String { return config.baseUrlString + config.apiKey + Constants.apiVersion }
    var wsConnectionURI: URL? { return buildURI() }
    var chatAuthMethod: String { return Constants.wsAuthMethod }
    var chatAuthEndpoint: String { return Constants.wsAuthEndpoint }

    init(config: ChatURIGeneratorConfig, authHelper: AuthHelper, deviceHandler: DeviceHandler) {
        self.authHelper = authHelper
        self.config = config
        self.deviceHandler = deviceHandler
    }

    private func buildURI() -> URL? {
        let generatedAuth = authHelper.authString(withEndpoint: Constants.wsAuthEndpoint,
                                                  method: Constants.wsAuthMethod,
                                                  body: "")

        guard let userAuth = generatedAuth,
            let auth = addingPercentEncoding(userAuth),
            let userAgent = addingPercentEncoding(authHelper.userAgent),
            let deviceID = addingPercentEncoding(deviceHandler.deviceIdentifier) else {
                assertionFailure()
                return nil
        }

        let urlString = urlWithApiKey + Constants.wsPart

        let wsUri = urlString
            + "?auth=" + auth
            + "&user-agent=" + userAgent
            + "&device-id" + deviceID

        return URL(string: wsUri)
    }

    private func addingPercentEncoding(_ target: String) -> String? {
        return target.addingPercentEncoding(withAllowedCharacters: Constants.allowedCharactersSet)
    }
}

extension SoulConfiguration {
    var chatURIGeneratorConfig: ChatURIGeneratorConfig {
        return ChatURIGeneratorConfig(baseUrlString: chatURL, apiKey: chatApiKey)
    }
}
