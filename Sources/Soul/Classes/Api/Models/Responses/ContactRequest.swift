import Foundation

public struct ContactRequest {

    enum Status: String, Codable {
        case sent, approved, declined, canceled
        var isSent: Bool {
            guard case .sent = self else { return false }
            return true
        }
        var isDeclined: Bool {
            guard case .declined = self else { return false }
            return true
        }
    }

    let identifier: String
    let toUser: String
    let fromUser: String
    var status: Status
}

extension ContactRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case toUser
        case fromUser
        case status
    }
}

struct MessageContactInfo {
    let userId: String
    let nickname: String
    let request: ContactRequest
}

extension MessageContactInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case userId
        case nickname
        case request
    }
}
