// swiftlint:disable nesting
public struct SoulBundle: Decodable {
    public let bundleName: String
    public let hasTrial: Bool
    public let order: Int?
    public let description: String?
    public let purchaseCount: Int
    public let products: [Product]?
    public let eligibleForDiscount: Bool?
    public let isAutorenewalEnabled: Bool?
    public let discountInfo: DiscountInfo?

    public struct Product: Decodable {
        let name: String?
        let type: ProductType?
        let lifeTimeSeconds: TimeInterval?
        let description: String?
        let trial: Bool?
        let quantity: Int?

        enum ProductType: String, Decodable {
            case consumable = "Consumable"
            case nonConsumable = "Non-consumable"
            case subscription = "Subscription"
            case autorenewable = "Autorenewal"
        }
    }

    public struct DiscountInfo: Decodable {
        public let screenName: String?
        public let offerKey: String?
        public let type: DiscountInfoType?

        public enum DiscountInfoType: String, Decodable {
            case autorenewalCanceledDuringTrialPeriod = "autorenewal_canceled_during_trial_period"
            case autorenewalCanceledDuringPaidPeriod = "autorenewal_canceled_during_paid_period"
            case trialPeriodExpired = "trial_period_expired"
            case paidPeriodExpired = "paid_period_expired"
        }
    }
}

extension SoulBundle: Hashable {

    public static func == (a: SoulBundle, b: SoulBundle) -> Bool {
        return a.bundleName == b.bundleName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bundleName)
    }
}
