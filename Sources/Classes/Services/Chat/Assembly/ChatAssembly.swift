import UIKit
import Swinject
import SwinjectAutoregistration

final class ChatAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ChatClientURIFactory.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIFactoryImpl.self, argument: config)
        }

        container.register(ChatApiURLFactory.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIFactoryImpl.self, argument: config)
        }

        container.register(ChatClientURIFactoryImpl.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClientURIFactoryImpl(config: config.chatURIFactoryConfig,
                                     authHelper: resolver ~> (AuthHelper.self, argument: config.appName),
                                     deviceHandler: resolver~>)
        }

        container.register(SocketFactory.self) { (resolver: Resolver, config: SoulConfiguration) in
            SocketFactoryImpl(uriFactory: resolver ~> (ChatClientURIFactory.self, argument: config))
        }

        container.register(ChatClientImpl.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClientImpl(socketFactory: resolver ~> (SocketFactory.self, argument: config),
                           errorService: resolver~>)
        }.inObjectScope(.weak)

        container.register(ChatClient.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientImpl.self, argument: config)
        }

        container.register(MessagesFactory.self) { resolver in
            MessagesFactoryImpl(storage: resolver~>)
        }

        container.register(EventFactory.self) { resolver in
            EventFactoryImpl(storage: resolver~>)
        }

        container.register(ChatServiceObserver.self) { (_: Resolver, client: ChatClient) in
            ChatServiceObserverImpl(chatClient: client)
        }.inObjectScope(.weak)

        container.register(ChatServiceMessageSender.self) { (resolver: Resolver, client: ChatClient) in
            ChatServiceMessageSenderImpl(chatClient: client,
                                         messagesFactory: resolver~>,
                                         eventFactory: resolver~>,
                                         errorService: resolver~>)
        }

        container.register(ChatHistoryService.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatHistoryServiceImpl(authHelper: resolver ~> (AuthHelper.self, argument: config.appName),
                                   urlFactory: resolver ~> (ChatApiURLFactory.self, argument: config),
                                   errorService: resolver~>)
        }

        container.register(MessageMapper.self) { resolver in
            MessageMapperImpl(storage: resolver~>)
        }

        container.register(ChatManager.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClient.self, argument: config)
            return ChatManagerImpl(chatServiceObserver: resolver ~> (ChatServiceObserver.self, argument: client),
                                   chatServiceMessageSender: resolver ~> (ChatServiceMessageSender.self, argument: client),
                                   chatHistoryService: resolver ~> (ChatHistoryService.self, argument: config),
                                   chatClient: resolver ~> (ChatClient.self, argument: config),
                                   pushManager: resolver ~> (ChatLocalPushManager.self, argument: config),
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
