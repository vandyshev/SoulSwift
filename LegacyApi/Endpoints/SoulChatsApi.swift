import Moya

typealias SoulChatsProvider = MoyaProvider<SoulChatsApi>

public enum SoulChatsApi {
    case chats
    case chatId(
        method: Moya.Method,
        chatId: String
    )
}

extension SoulChatsApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .chats:
            return "/chats"
        case .chatId(_, let chatId):
            return "/chats/\(chatId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .chats:
            return .get
        case .chatId(let method, _):
            return method
        }
    }

    public var task: Task {
        return .requestPlain
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return [:]
    }
}
