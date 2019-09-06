import UIKit

enum ChatPayload: Equatable {
    case message(MessagePayload)
    case event(EventPayload)
}

extension ChatPayload: Codable {

    enum CodingError: Error { case decoding }

    init(from decoder: Decoder) throws {
        if let message = try? MessagePayload(from: decoder) {
            self = .message(message)
            return
        }
        if let event = try? EventPayload(from: decoder) {
            self = .event(event)
            return
        }
        throw CodingError.decoding
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case let .message(message):
            try message.encode(to: encoder)
        case let .event(event):
            try event.encode(to: encoder)
        }
    }
}
