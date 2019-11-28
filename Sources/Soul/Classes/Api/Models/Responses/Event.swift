public struct Event: Decodable {

    public let recordId: String?
    public let time: TimeInterval?
    public let action: ActionType?
    public let object: ObjectType?

    enum CodingKeys: String, CodingKey {
        case recordId
        case time
        case type
        case object
    }

    enum EventTypeCodingKeys: String, CodingKey {
        case object
        case action
    }

    public enum ObjectType {
        case user(User)
        case endpoint(Endpoint)
        case chat(Chat)
        case reactions(Reactions)
        case me(MyUser)

        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case user
            case endpoint
            case chat
            case reactions
            case me
        }
    }

    public enum ActionType: String, Decodable {
        case change
        case addition
        case kicked
        case photoRemoved = "photo_removed"
        case banned
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordId = try container.decodeIfPresent(String.self, forKey: .recordId)
        time = try container.decodeIfPresent(TimeInterval.self, forKey: .time)
        let typeContainer = try container.nestedContainer(keyedBy: EventTypeCodingKeys.self, forKey: .type)
        action = try typeContainer.decode(ActionType.self, forKey: .action)

        let objectType = try typeContainer.decode(String.self, forKey: .object)
        switch objectType {
        case ObjectType.CodingKeys.me.rawValue:
            let me = try container.decode(MyUser.self, forKey: .object)
            object = .me(me)
        case ObjectType.CodingKeys.user.rawValue:
            let user = try container.decode(User.self, forKey: .object)
            object = .user(user)
        case ObjectType.CodingKeys.endpoint.rawValue:
            let endpoint = try container.decode(Endpoint.self, forKey: .object)
            object = .endpoint(endpoint)
        case ObjectType.CodingKeys.chat.rawValue:
            let chat = try container.decode(Chat.self, forKey: .object)
            object = .chat(chat)
        case ObjectType.CodingKeys.reactions.rawValue:
            let reactions = try container.decode(Reactions.self, forKey: .object)
            object = .reactions(reactions)
        default:
            object = nil
        }
    }
}

public struct Endpoint: Decodable {
    let type: String
    let uri: String
}
