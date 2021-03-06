import Foundation

public struct Participant: Decodable {
    public let userId: String
    public let status: Status?
    public var user: User?
    public var contact: Contact?

    public enum Status: String, Decodable {
        case active = "active"
        case escape = "deleted"
    }
}
