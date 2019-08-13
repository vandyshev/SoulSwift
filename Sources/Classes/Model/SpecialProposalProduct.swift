import Foundation

struct SpecialProposalProduct {
    var bundle: String
    var time: Date
}

extension SpecialProposalProduct {
    static func create() -> SpecialProposalProduct {
        return SpecialProposalProduct(bundle: "org.getpure.pure.MonthSpecial", time: Date())
    }
}

//extension SpecialProposalProduct {
//    static func from(_ parameters: [AnyHashable: Any]) -> SpecialProposalProduct? {
//        guard let object = parameters[DomainKeys.specialProposalProduct.rawValue] as? [String: Any] else {
//            return nil
//        }
//
//        if let bundle = object["bundle"] as? String, let time = object["time"] as? Int {
//            return SpecialProposalProduct(bundle: bundle, time: Date(timeIntervalSince1970: TimeInterval(time)))
//        }
//
//        return nil
//    }
//
//    static func to(_ product: SpecialProposalProduct) -> [String: Any] {
//        var result = [String: Any]()
//        result["bundle"] = product.bundle
//        result["time"] = Int(product.time.timeIntervalSince1970)
//        return result
//    }
//}
