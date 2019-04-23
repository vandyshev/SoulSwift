import UIKit
import Swinject
import SwinjectAutoregistration

final class ChatAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ChatClientURIGenerator.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClientURIGeneratorImpl(config: config.chatURIGeneratorConfig,
                                       authHelper: resolver ~> (AuthHelper.self, argument: config.appName))
        }
        container.register(ChatClient.self) { ( resolver: Resolver, config: SoulConfiguration) in
            ChatClientImpl(uriGenerator: resolver ~> (ChatClientURIGenerator.self, argument: config))
        }
        container.register(MessagesGenerator.self) { resolver in
            MessagesGeneratorImpl(storage: resolver~>)
        }
        container.register(EventGenerator.self) { resolver in
            EventGeneratorImpl(storage: resolver~>)
        }
        container.register(ChatService.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClient.self, argument: config)
            return ChatServiceImpl(chatClient: client,
                                   messagesGenerator: resolver~>,
                                   eventGenerator: resolver~>)
        }
    }
}
