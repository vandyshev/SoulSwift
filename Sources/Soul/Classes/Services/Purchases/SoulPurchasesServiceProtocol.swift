public protocol SoulPurchasesServiceProtocol {
    func allPurchases(completion: @escaping (Result<[SoulBundle], SoulSwiftError>) -> Void)
    func myPurchases(completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void)
    func orderAppstore(receipt: String, completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void)
}

final class SoulPurchasesService: SoulPurchasesServiceProtocol {

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
            // SoulSwift: Тут скорее всего будет nil
            completion(result.map { $0.bundles_v2 })
        }
    }

    func myPurchases(completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulPurchasesEndpoint.my,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.bundles_v2, $0.items) })
        }
    }

    func orderAppstore(receipt: String, completion: @escaping (Result<([SoulBundle], [InventoryItem]), SoulSwiftError>) -> Void) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulPurchasesEndpoint.orderAppstore,
            needAuthorization: true
        )
        request.setQueryParameters(["receipt": receipt])
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { ($0.bundles_v2, $0.items) })
        }
    }
}
