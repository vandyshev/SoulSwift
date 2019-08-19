import Foundation

struct Chat {
    var ident: String
    var messages: [Message]
    var partner: Participant?
    var expiresDate: Date
    var channelName: String
    var creatorId: String
    var expired: Bool
    var escaped: Bool
    var type: ChatType
}

enum ChatType: Int, Comparable {
    case regular = 0, instant

    private var sortOrder: Int {
        switch self {
        case .regular: return 0
        case .instant: return 1
        }
    }

    static func == (lhs: ChatType, rhs: ChatType) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }

    static func < (lhs: ChatType, rhs: ChatType) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}

extension Chat {
    var isInstant: Bool {
        return type == .instant
    }
}

struct ChatEvent {
    var chat: Chat
    var action: EventAction
}

enum EventAction {
    case addition, change, remove
}
