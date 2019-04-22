import Foundation

/// This event mean that this message have been sent by current user from the other device

struct HistorySyncEvent {
    let time: UnixTimeStamp          /// `t` - unix timestamp // TODO: check int or double
    private let syncEvent: SyncEvent /// `h` - SyncEvent
}

extension HistorySyncEvent {
    var userId: String { return syncEvent.userId }
    var deviceId: String { return syncEvent.deviceId }
    var message: ChatMessage { return syncEvent.message }
}

private struct SyncEvent {
    let userId: String       /// `u` - user id
    let deviceId: String     /// `d` - device id
    let message: ChatMessage /// `m` - message dict
}

extension HistorySyncEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case time      = "t"
        case syncEvent = "h"
    }
}

extension SyncEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case userId   = "u"
        case deviceId = "d"
        case message  = "m"
    }
}
