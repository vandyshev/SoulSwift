import Foundation

struct EventPayload {
    let channel: String
    let event: EventType
}

extension EventPayload: Codable { }
