public struct MyUserParameters: Codable {
    let filterable: FilterableParameters?
    let publicVisible: PublicVisibleParameters?
    let publicWritable: PublicWritableParameters?
    let `private`: PrivateParameters?
}

public struct FilterableParameters: Codable {
    let gender: Gender?
    let lookingFor: Gender?
    let location: Coordinates?
    let availableTill: TimeInterval?
}

public struct PublicVisibleParameters: Codable {

}

public struct PublicWritableParameters: Codable {

}

// swiftlint:disable nesting
public struct PrivateParameters: Codable {
    public struct SoulSettings: Codable {
        public struct ReceiveNotifications: Codable {
            let reaction: Bool?
            let chat: Bool?
        }
        let receiveNotifications: ReceiveNotifications?
    }

    public struct UsageHistory: Codable {
        let records: [TimeInterval]?
        let total: Int?
    }

    let isAgreeToReceiveNewsAndStories: Bool?
    let nosoul: Bool?
    let availabilitySessionId: String?
    let availabilitySessionStart: TimeInterval?
    let viewingSession: String?
    let soulSettings: SoulSettings?
    let usageHistory: UsageHistory?
    let distinctId: String?
    let cleaned: Bool?
    let hasWebSocketConnection: Bool?
    let retention: Bool?

    enum CodingKeys: String, CodingKey {
        case isAgreeToReceiveNewsAndStories
        case nosoul
        case availabilitySessionId = "availability_session_id"
        case availabilitySessionStart = "availability_session_start"
        case viewingSession
        case soulSettings
        case usageHistory
        case distinctId
        case cleaned
        case hasWebSocketConnection
        case retention
    }
}
