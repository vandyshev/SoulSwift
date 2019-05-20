import UIKit
import Swinject
import SwinjectAutoregistration

final class ChatAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ChatClientURIGenerator.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIGeneratorImpl.self, argument: config)
        }

        container.register(ChatApiURLGenerator.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIGeneratorImpl.self, argument: config)
        }

        container.register(ChatClientURIGeneratorImpl.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClientURIGeneratorImpl(config: config.chatURIGeneratorConfig,
                                       authHelper: resolver ~> (AuthHelper.self, argument: config.appName),
                                       deviceHandler: resolver~>)
        }

        container.register(ChatClientImpl.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClientImpl(uriGenerator: resolver ~> (ChatClientURIGenerator.self, argument: config))
        }.inObjectScope(.weak)

        container.register(ChatClient.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientImpl.self, argument: config)
        }

        container.register(ChatClienStatusProvider.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientImpl.self, argument: config)
        }

        container.register(MessagesGenerator.self) { resolver in
            MessagesGeneratorImpl(storage: resolver~>)
        }

        container.register(EventGenerator.self) { resolver in
            EventGeneratorImpl(storage: resolver~>)
        }

        container.register(ChatServiceObserver.self) { (_: Resolver, client: ChatClient) in
            ChatServiceObserverImpl(chatClient: client)
        }.inObjectScope(.weak)

        container.register(ChatServiceMessageSender.self) { (resolver: Resolver, client: ChatClient) in
            ChatServiceMessageSenderImpl(chatClient: client,
                                         messagesGenerator: resolver~>,
                                         eventGenerator: resolver~>)
        }

        container.register(ChatHistoryService.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatHistoryServiceImpl(authHelper: resolver ~> (AuthHelper.self, argument: config.appName),
                                   urlGenerator: resolver ~> (ChatApiURLGenerator.self, argument: config))
        }

        container.register(MessageMapper.self) { resolver in
            MessageMapperImpl(storage: resolver~>)
        }

        container.register(ChatManager.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClient.self, argument: config)
            return ChatManagerImpl(chatServiceObserver: resolver ~> (ChatServiceObserver.self, argument: client),
                                   chatServiceMessageSender: resolver ~> (ChatServiceMessageSender.self, argument: client),
                                   chatHistoryService: resolver ~> (ChatHistoryService.self, argument: config),
                                   chatStatusProvider: resolver ~> (ChatClienStatusProvider.self, argument: config),
                                   messageMapper: resolver~>)
        }

        container.register(ChatLocalPushManager.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClient.self, argument: config)
            let chatServiceObserver = resolver ~> (ChatServiceObserver.self, argument: client)
            return ChatLocalPushManagerImpl(chatServiceObserver: chatServiceObserver,
                                            localPushService: resolver~>)
        }
    }
}
