public struct InventoryItem: Decodable {
    public let id: String
    public let disableFreeToPlayLimits: Bool?
    public let disableAdvertisement: Bool?
    public let validBefore: TimeInterval?
    public let name: String?
    public let validBeforeStrict: TimeInterval?
    public let quantity: Int?
    public let type: InventoryItemType?
    public let description: String?

    public enum InventoryItemType: String, Decodable {
        case consumable = "Consumable"
        case nonConsumable = "Non-consumable"
        case subscription = "Subscription"
        case autorenewable = "Autorenewal"
    }
}
