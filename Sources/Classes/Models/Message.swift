import Foundation

enum MessageContent {
    case text
    case image(photoId: String, albumName: String)
    case location(coordinates: Coordinates)
    case system
    case unknown
}

enum MessageDirection {
    case outgoing
    case income
    case unknown
}

extension MessageDirection {
    var isIncome: Bool {
        guard case .income = self else { return false }
        return true
    }
}

class Message {

    let ident: String
    let date: Date
    let text: String?
    let userId: String?
    let attachment: MessageContent
    let direction: MessageDirection
    var viewed: Bool

    init(ident: String,
         date: Date,
         text: String?,
         userId: String?,
         attachment: MessageContent,
         direction: MessageDirection,
         viewed: Bool) {
        self.ident = ident
        self.date = date
        self.text = text
        self.userId = userId
        self.attachment = attachment
        self.direction = direction
        self.viewed = viewed
    }

    private static let componentFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        return dateFormatter
    }()

//    func timeAgo() -> String? {
//        let secondsLeft = Int(Date.now().timeIntervalSince(date))
//        let minutesLeft = (secondsLeft / 60)
//
//        var timeAgo: String?
//        // if `minutesLeft` less than 1 - "less than a minute ago"
//        // if `minutesLeft` less than an hour - "X minutes ago"
//        // if `minutesLeft` great than an hour - "Sen 25, 11:51"
//        if minutesLeft <= 0 {
//            timeAgo = Localization.Chat.Time.lessThanMinuteAgo
//        } else if minutesLeft < 60 {
//            if let string = Message.componentFormatter.string(from: DateComponents(minute: minutesLeft)) {
//                timeAgo = "\(string) \(Localization.Common.ago)"
//            }
//        } else {
//            timeAgo = Message.dateFormatter.string(from: date)
//        }
//
//        return timeAgo
//    }
}

extension Message: Hashable {

    static func == (a: Message, b: Message) -> Bool {
        return a.ident == b.ident
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ident)
    }
}

enum MessagePostAttachment {
    case text
    case image(imageData: Data)
    case location(coordinates: Coordinates)

//    func pushPayload(_ chat: Chat) -> AnyDictionary {
//        let sound, locKey: String
//
//        switch self {
//        case .text:
//            sound = "default"
//            locKey = "chat_message_text"
//        case .image:
//            sound = "default"
//            locKey = "chat_message_photo"
//        case .location:
//            sound = "default"
//            locKey = "chat_message_location"
//        }
//
//        return [
//            "sound": sound,
//            "chatId": chat.ident,
//            "alert": [
//                "loc-key": locKey
//            ]
//        ]
//    }
}

struct MessagePostModel {
    var text: String?
    var attachment: MessagePostAttachment
}

enum CallMessageType {
    case outgoing(id: String, time: Double)
    case aborted(id: String)
    case declined(id: String)
    case answered(id: String)
    case ended(id: String, duration: Int)
}
