public struct InventoryItem: Decodable {
    let id: String
    let disableFreeToPlayLimits: Bool?
    let disableAdvertisement: Bool?
    let validBefore: TimeInterval?
    let name: String?
    let validBeforeStrict: TimeInterval?
    let quantity: Int?
    let type: String?
    let description: String?
}
