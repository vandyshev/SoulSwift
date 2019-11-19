public struct Inventory: Decodable {
    public let bundles: [String]
    public let bundles_v2: [SoulBundle]
    public let items: [InventoryItem]
}
