// swiftlint:disable nesting
public struct MyUser: Codable {
    public let id: String
    public let parameters: MyUserParameters?
    public let notificationTokens: NotificationTokens?
    public let albums: [Album]?

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
        case albums
    }
}
