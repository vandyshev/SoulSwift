public struct MyUser: Codable {
    // TODO: SoulSwift: Rename to id
    public let id: String
    public let parameters: MeParameters?
    public let notificationTokens: NotificationTokens?

    public struct NotificationTokens: Codable {
        let apns: String?

        enum CodingKeys: String, CodingKey {
            case apns = "APNS"
        }
    }


    enum CodingKeys: String, CodingKey {
        case id
        case parameters
        case notificationTokens
    }
}
