import Foundation

public struct MyUser: Codable {
    // TODO: SoulSwift: Rename to id
    public let id: String

    enum CodingKeys: String, CodingKey {
        case id
//        case gender
    }
}
