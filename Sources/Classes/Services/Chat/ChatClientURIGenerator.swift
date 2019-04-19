import UIKit

/// generates uri for ChatClient
protocol ChatClientURIGenerator {
    var uri: URL? { get }
}

public struct ChatURIGeneratorConfig {
    let baseUrlString: String // should be declared with scheme, with port and with last `/` character
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
        static let wsApiVersion = "/v1/ws"
        static let allowedCharactersSet = CharacterSet(charactersIn: " ;").inverted
    }

    private let config: ChatURIGeneratorConfig
    private let authHelper: AuthHelper

    var uri: URL? { return buildURI() }

    init(config: ChatURIGeneratorConfig, authHelper: AuthHelper) {
        self.authHelper = authHelper
        self.config = config
    }

    private func buildURI() -> URL? {
        let generatedAuth = authHelper.authString(withEndpoint: Constants.wsAuthEndpoint,
                                                  method: Constants.wsAuthMethod,
                                                  body: "")

        let characterSet = Constants.allowedCharactersSet
        let generateUserAgent = authHelper.userAgent

        guard let userAuth = generatedAuth,
            let auth = userAuth.addingPercentEncoding(withAllowedCharacters: characterSet),
            let userAgent = generateUserAgent.addingPercentEncoding(withAllowedCharacters: characterSet) else {
                assertionFailure()
                return nil
        }

        let urlString = config.baseUrlString + config.apiKey + Constants.wsApiVersion

        let wsUri = urlString
            + "?auth=" + auth
            + "&user-agent=" + userAgent
        
        return URL(string: wsUri)
    }
}

extension SoulConfiguration {
    var chatURIGeneratorConfig: ChatURIGeneratorConfig {
        return ChatURIGeneratorConfig(baseUrlString: chatURL, apiKey: chatApiKey)
    }
}
