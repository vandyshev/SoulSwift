import Foundation

/// This event mean that this message have been sent by current user from the other device
struct HistorySyncEvent: Equatable {

    /// `t` - unix timestamp
    let time: UnixTimeStamp
    
    /// `h` - SyncEvent
    private let syncEvent: SyncEvent
}

extension HistorySyncEvent {
    init(time: UnixTimeStamp, userId: String, deviceId: String, message: ChatMessage) {
        self.time = time
        self.syncEvent = SyncEvent(userId: userId, deviceId: deviceId, message: message)
    }
}

extension HistorySyncEvent {
    var userId: String { return syncEvent.userId }
    var deviceId: String { return syncEvent.deviceId }
    var message: ChatMessage { return syncEvent.message }
}

private struct SyncEvent: Equatable {

    /// `u` - user id
    let userId: String
    
    /// `d` - device id
    let deviceId: String
    
    /// `m` - message dict
    let message: ChatMessage
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
