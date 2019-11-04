import UIKit
import Swinject
import SwinjectAutoregistration

final class ChatAssembly: Assembly {

    // swiftlint:disable function_body_length
    func assemble(container: Container) {

        container.register(ChatClientURIFactoryProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIFactory.self, argument: config)
        }

        container.register(ChatApiURLFactoryProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClientURIFactory.self, argument: config)
        }

        container.register(ChatClientURIFactory.self) { (resolver: Resolver, config: DreamConfiguration) in
            ChatClientURIFactory(config: DreamClient.shared.dreamConfiguration.chatURIFactoryConfig,
                                     authHelper: resolver ~> (AuthHelperProtocol.self, argument: SoulClient.shared.soulConfiguration.appName),
                                     deviceHandler: resolver~>)
        }

        container.register(SocketFactoryProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            SocketFactory(uriFactory: resolver ~> (ChatClientURIFactoryProtocol.self, argument: config))
        }

        container.register(ChatClient.self) { (resolver: Resolver, config: SoulConfiguration) in
            ChatClient(socketFactory: resolver ~> (SocketFactoryProtocol.self, argument: config),
                           errorService: resolver~>)
        }.inObjectScope(.weak)

        container.register(ChatClientProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            resolver ~> (ChatClient.self, argument: config)
        }

        container.register(MessagesFactoryProtocol.self) { resolver in
            MessagesFactory(storage: resolver~>, dateService: resolver~>)
        }

        container.register(EventFactoryProtocol.self) { resolver in
            EventFactory(storage: resolver~>, dateService: resolver~>)
        }

        container.register(ChatServiceObserverProtocol.self) { (_: Resolver, client: ChatClientProtocol) in
            ChatServiceObserver(chatClient: client)
        }.inObjectScope(.weak)

        container.register(ChatServiceMessageSenderProtocol.self) { (resolver: Resolver, client: ChatClientProtocol) in
            ChatServiceMessageSender(chatClient: client,
                                         messagesFactory: resolver~>,
                                         eventFactory: resolver~>,
                                         errorService: resolver~>)
        }

//        container.register(ChatHistoryServiceProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
//            ChatHistoryService(authHelper: resolver ~> (AuthHelperProtocol.self, argument: config.appName),
//                                   urlFactory: resolver ~> (ChatApiURLFactoryProtocol.self, argument: config),
//                                   errorService: resolver~>)
//        }

        container.autoregister(DreamChatServiceProtocol.self, initializer: DreamChatService.init)

        container.register(MessageMapperProtocol.self) { resolver in
            MessageMapper(storage: resolver~>)
        }

        container.register(ChatManagerProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClientProtocol.self, argument: config)
            return ChatManager(chatServiceObserver: resolver ~> (ChatServiceObserverProtocol.self, argument: client),
                                   chatServiceMessageSender: resolver ~> (ChatServiceMessageSenderProtocol.self, argument: client),
                                   chatHistoryService: resolver ~> (DreamChatServiceProtocol.self, argument: config),
                                   chatClient: resolver ~> (ChatClientProtocol.self, argument: config),
                                   pushManager: resolver ~> (ChatLocalPushManagerProtocol.self, argument: config),
                                   messageMapper: resolver~>,
                                   dateService: resolver~>)
        }

        container.register(ChatLocalPushManagerProtocol.self) { (resolver: Resolver, config: SoulConfiguration) in
            let client = resolver ~> (ChatClientProtocol.self, argument: config)
            let chatServiceObserver = resolver ~> (ChatServiceObserverProtocol.self, argument: client)
            return ChatLocalPushManager(chatServiceObserver: chatServiceObserver,
                                            localPushService: resolver~>)
        }
    }
}
