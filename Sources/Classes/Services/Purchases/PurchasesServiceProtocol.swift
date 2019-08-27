public protocol PurchasesServiceProtocol {
    func allPurchases(completion: @escaping (Result<[SoulBundle], SoulSwiftError>) -> Void)
    func myPurchases(completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void)
    func orderAppstore(receipt: String, completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void)
}

final class PurchasesService: PurchasesServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func allPurchases(completion: @escaping (Result<[SoulBundle], SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulPurchasesEndpoint.all,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.bundles })
        }
    }

    func myPurchases(completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulPurchasesEndpoint.my,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.bundles, $0.items) })
        }
    }

    func orderAppstore(receipt: String, completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulPurchasesEndpoint.orderAppstore,
            bodyParameters: ["receipt": receipt],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.bundles, $0.items) })
        }
    }
}
