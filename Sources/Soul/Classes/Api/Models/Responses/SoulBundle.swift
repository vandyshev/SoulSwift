public struct SoulBundle: Decodable {
    let bundleName: String
    let hasTrial: Bool?
    let order: Int?
    let description: String?
    let purchaseCount: Int?
    let products: [Product]?
    let eligibleForDiscount: Bool?
    let isAutorenewalEnabled: Bool?

    public struct Product: Decodable {
        let name: String?
        let type: String?
        let lifeTimeSeconds: TimeInterval?
        let description: String?
        let trial: Bool?
        let quantity: Int?
    }
}
