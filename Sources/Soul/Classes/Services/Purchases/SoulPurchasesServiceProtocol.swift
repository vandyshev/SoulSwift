public protocol SoulPurchasesServiceProtocol {
    // POST: /purchases/all
    func allPurchases(completion: @escaping SoulResult<[SoulBundle]>.Completion)
    // POST: /purchases/my
    func myPurchases(completion: @escaping SoulResult<Inventory>.Completion)
    // POST: /purchases/order/appstore
    func orderAppstore(receipt: String, completion: @escaping SoulResult<Inventory>.Completion)
    // POST: /purchases/order/appstore/sign
    func signatureRequest(appBundleId: String, productId: String, offerId: String, applicationUsername: String, completion: @escaping SoulResult<Signature>.Completion)
    // POST: /purchases/consume
    func consumeItem(itemId: String, quantity: Int, consumptionId: String, completion: @escaping SoulResult<Inventory>.Completion)
}

final class SoulPurchasesService: SoulPurchasesServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func allPurchases(completion: @escaping SoulResult<[SoulBundle]>.Completion) {
        let request = SoulRequest(
            soulEndpoint: SoulPurchasesEndpoint.all,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            // SoulSwift: Тут скорее всего будет nil
            completion(result.map { $0.bundles_v2 })
        }
    }

    func myPurchases(completion: @escaping SoulResult<Inventory>.Completion) {
        let request = SoulRequest(
            soulEndpoint: SoulPurchasesEndpoint.my,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<Inventory, SoulSwiftError>) in
            completion(result)
        }
    }

    func orderAppstore(receipt: String, completion: @escaping SoulResult<Inventory>.Completion) {
        var request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulPurchasesEndpoint.orderAppstore,
            needAuthorization: true
        )
        request.setQueryParameters(["receipt": receipt])
        soulProvider.request(request) { (result: Result<Inventory, SoulSwiftError>) in
            completion(result)
        }
    }

    func signatureRequest(appBundleId: String, productId: String, offerId: String, applicationUsername: String, completion: @escaping SoulResult<Signature>.Completion) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulPurchasesEndpoint.signatureRequest,
            needAuthorization: true
        )
        request.setBodyParameters(["appBundleId": appBundleId,
                                   "productId": productId,
                                   "offerId": offerId,
                                   "applicationUsername": applicationUsername
        ])
        soulProvider.request(request) { (result: Result<Signature, SoulSwiftError>) in
            completion(result)
        }
    }

    func consumeItem(itemId: String, quantity: Int, consumptionId: String, completion: @escaping SoulResult<Inventory>.Completion) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulPurchasesEndpoint.consume,
            needAuthorization: true
        )
        request.setBodyParameters(["itemId": itemId,
                                   "quantity": quantity,
                                   "consumptionId": consumptionId,
        ])
        soulProvider.request(request) { (result: Result<Inventory, SoulSwiftError>) in
            completion(result)
        }
    }
}
