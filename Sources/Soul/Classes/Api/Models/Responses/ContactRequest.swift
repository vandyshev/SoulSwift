import Foundation

public struct ContactRequest {

    public enum Status: String, Codable {
        case sent, approved, declined, canceled
        public var isSent: Bool {
            guard case .sent = self else { return false }
            return true
        }
        public var isDeclined: Bool {
            guard case .declined = self else { return false }
            return true
        }
    }

    public let identifier: String
    public let toUser: String
    public let fromUser: String
    public var status: Status
}

extension ContactRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case toUser
        case fromUser
        case status
    }
}

public struct MessageContactInfo {
    public let userId: String
    public let nickname: String
    public let request: ContactRequest
}

extension MessageContactInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case userId
        case nickname
        case request
    }
}
