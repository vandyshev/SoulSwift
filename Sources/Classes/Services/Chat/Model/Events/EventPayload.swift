import Foundation

/// Event payload. It contains channel name and event
struct EventPayload: Equatable, Codable {

    /// `channel` - channel name
    let channel: String

    /// `event` - chat event
    let event: EventType
}
