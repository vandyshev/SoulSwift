import Foundation

public struct Event: Decodable {

    public let recordId: Int?
    public let time: TimeInterval?
    public let event: TypedEvent?

    enum CodingKeys: String, CodingKey {
        case recordId
        case time
        case type
        case object
    }

    enum TypeCodingKeys: String, CodingKey {
        case object
        case action
    }

    enum ObjectTypes: String, Decodable {
        case user
        case endpoint
        case chat
        case reaction
        case me
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordId = try? container.decodeIfPresent(Int.self, forKey: .recordId)
        time = try? container.decodeIfPresent(TimeInterval.self, forKey: .time)

        do {
            let typeContainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
            let objectType = try typeContainer.decode(ObjectTypes.self, forKey: .object)
            switch objectType {
            case .me:
                let me = try container.decode(MyUser.self, forKey: .object)
                let action = try typeContainer.decode(TypedEvent.MyUserAction.self, forKey: .action)
                event = .me(TypedEvent.MyUserEvent(me: me, action: action))
            case .user:
                let user = try container.decode(User.self, forKey: .object)
                let action = try typeContainer.decode(TypedEvent.UserAction.self, forKey: .action)
                event = .user(TypedEvent.UserEvent(user: user, action: action))
            case .endpoint:
                let endpoint = try container.decode(Endpoint.self, forKey: .object)
                let action = try typeContainer.decode(TypedEvent.EndpointAction.self, forKey: .action)
                event = .endpoint(TypedEvent.EndpointEvent(endpoint: endpoint, action: action))
            case .chat:
                let chat = try container.decode(Chat.self, forKey: .object)
                let action = try typeContainer.decode(TypedEvent.ChatAction.self, forKey: .action)
                event = .chat(TypedEvent.ChatEvent(chat: chat, action: action))
            case .reaction:
                let reactions = try container.decode(Reactions.self, forKey: .object)
                let action = try typeContainer.decode(TypedEvent.ReactionsAction.self, forKey: .action)
                event = .reactions(TypedEvent.ReactionsEvent(reactions: reactions, action: action))
            }
        } catch {
            event = nil
        }
    }
}

public enum TypedEvent {

    case user(UserEvent)
    case endpoint(EndpointEvent)
    case chat(ChatEvent)
    case reactions(ReactionsEvent)
    case me(MyUserEvent)

    public struct UserEvent {
        public let user: User
        public let action: UserAction

        public init(user: User, action: UserAction) {
            self.user = user
            self.action = action
        }
    }

    public enum UserAction: String, Decodable {
        case change
        case addition
        case kicked
        case photoRemoved = "photo_removed"
        case banned
    }

    public struct EndpointEvent {
        public let endpoint: Endpoint
        public let action: EndpointAction

        public init(endpoint: Endpoint, action: EndpointAction) {
            self.endpoint = endpoint
            self.action = action
        }
    }

    public enum EndpointAction: String, Decodable {
        case addition
        case change
    }

    public struct ChatEvent {
        public let chat: Chat
        public let action: ChatAction

        public init(chat: Chat, action: ChatAction) {
            self.chat = chat
            self.action = action
        }
    }

    public enum ChatAction: String, Decodable {
        case change
        case addition
        case remove
    }

    public struct ReactionsEvent {
        public let reactions: Reactions
        public let action: ReactionsAction

        public init(reactions: Reactions, action: ReactionsAction) {
            self.reactions = reactions
            self.action = action
        }
    }

    public enum ReactionsAction: String, Decodable {
        case change
        case addition
    }

    public struct MyUserEvent {
        public let me: MyUser
        public let action: MyUserAction

        public init(me: MyUser, action: MyUserAction) {
            self.me = me
            self.action = action
        }
    }

    public enum MyUserAction: String, Decodable {
        case change
        case addition
    }
}
