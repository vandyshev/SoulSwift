import Foundation

public struct Participant: Decodable {
    public let userId: String
    public let status: Status?
    public var user: User?
    public var contactNickName: String?

    public enum Status: String, Decodable {
        case active = "active"
        case escape = "deleted"
    }
}
