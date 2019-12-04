enum SoulPurchasesEndpoint {
    case orderAppstore
    case all
    case my
    case signatureRequest
    case consume
}

extension SoulPurchasesEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .orderAppstore:
            return "/purchases/order/appstore"
        case .all:
            return "/purchases/all"
        case .my:
            return "/purchases/my"
        case .signatureRequest:
            return "/purchases/order/appstore/sign"
        case .consume:
            return "/purchases/consume"
        }
    }
}
