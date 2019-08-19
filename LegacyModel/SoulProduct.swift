import Foundation

struct SoulProduct {
    var name: String
    var description: String
    var trial: Bool
    var type: SoulProductType
    var quantity: Int
    var lifeTime: Int
}

enum SoulProductType {
    case unknown
    case consumable
    case nonConsumable
    case subscription
    case autorenewable
}
