public struct MyUserParameters: Codable {

    public let filterable: FilterableParameters?
    public let publicVisible: PublicVisibleParameters?
    public let publicWritable: PublicWritableParameters?
    public let `private`: PrivateParameters?

    public init(filterable: FilterableParameters? = nil,
                publicVisible: PublicVisibleParameters? = nil,
                publicWritable: PublicWritableParameters? = nil,
                private: PrivateParameters? = nil) {
        self.filterable = filterable
        self.publicVisible = publicVisible
        self.publicWritable = publicWritable
        self.private = `private`
    }
}

public struct FilterableParameters: Codable {

    public let gender: Gender?
    public let lookingFor: Gender?
    public let location: Coordinates?
    public let availableTill: TimeInterval?

    public init(gender: Gender? = nil,
                lookingFor: Gender? = nil,
                location: Coordinates? = nil,
                availableTill: TimeInterval? = nil) {
        self.gender = gender
        self.lookingFor = lookingFor
        self.location = location
        self.availableTill = availableTill
    }
}

public struct PublicVisibleParameters: Codable {

}

public struct PublicWritableParameters: Codable {

}

// swiftlint:disable nesting
public struct PrivateParameters: Codable {
    public class SoulSettings: Codable {
        public class ReceiveNotifications: Codable {
            public let reaction: Bool?
            public let chat: Bool?

            public init(reaction: Bool? = nil,
                        chat: Bool? = nil) {
                self.reaction = reaction
                self.chat = chat
            }
        }

        public let receiveNotifications: ReceiveNotifications?

        public init(receiveNotifications: ReceiveNotifications? = nil) {
            self.receiveNotifications = receiveNotifications
        }
    }

    public struct UsageHistory: Codable {
        public let records: [TimeInterval]?
        public let total: Int?

        public init(records: [TimeInterval]? = nil,
                    total: Int? = nil) {
            self.records = records
            self.total = total
        }
    }

    public class Branch: Codable {
        public let clientId: String?

        public init(clientId: String? = nil) {
            self.clientId = clientId
        }

        enum CodingKeys: String, CodingKey {
            case clientId = "client_id"
        }
    }

    public let isAgreeToReceiveNewsAndStories: Bool?
    public let nosoul: Bool?
    public let availabilitySessionId: String?
    public let availabilitySessionStart: TimeInterval?
    public let viewingSession: String?
    public let soulSettings: SoulSettings?
    public let usageHistory: UsageHistory?
    public let distinctId: String?
    public let cleaned: Bool?
    public let hasWebSocketConnection: Bool?
    public let retention: Bool?
    public let consents: AnyCodable?
    public let branch: Branch?

    public init(isAgreeToReceiveNewsAndStories: Bool? = nil,
                nosoul: Bool? = nil,
                availabilitySessionId: String? = nil,
                availabilitySessionStart: TimeInterval? = nil,
                viewingSession: String? = nil,
                soulSettings: SoulSettings? = nil,
                usageHistory: UsageHistory? = nil,
                distinctId: String? = nil,
                cleaned: Bool? = nil,
                hasWebSocketConnection: Bool? = nil,
                retention: Bool? = nil,
                consents: AnyCodable? = nil,
                branch: Branch? = nil) {
        self.isAgreeToReceiveNewsAndStories = isAgreeToReceiveNewsAndStories
        self.nosoul = nosoul
        self.availabilitySessionId = availabilitySessionId
        self.availabilitySessionStart = availabilitySessionStart
        self.viewingSession = viewingSession
        self.soulSettings = soulSettings
        self.usageHistory = usageHistory
        self.distinctId = distinctId
        self.cleaned = cleaned
        self.hasWebSocketConnection = hasWebSocketConnection
        self.retention = retention
        self.consents = consents
        self.branch = branch
    }

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
        case consents
        case branch
    }
}
