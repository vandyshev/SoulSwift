import Foundation

struct Authorization: Decodable {
    let sessionToken: String
    let expiresTime: TimeInterval
}
