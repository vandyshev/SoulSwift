import Foundation

struct UsageHistory {
    var total: Int
    var records: [Date]
}

//extension UsageHistory {
//    static func from(_ parameters: [AnyHashable: Any]) -> UsageHistory? {
//        guard let object = parameters[DomainKeys.UsageHistory.rawValue] as? [String: Any] else {
//            return nil
//        }
//
//        let total = object["total"] as? Int ?? 0
//
//        var records = object["records"] as? [Int] ?? [Int]()
//        records = records.sorted(by: { $0 > $1 })
//
//        return UsageHistory(total: total, records: records.map({ Date(timeIntervalSince1970: TimeInterval($0)) }))
//    }
//
//    static func to(_ usageHistory: UsageHistory) -> [String: Any] {
//        var result = [String: Any]()
//        result["total"] = usageHistory.total
//        result["records"] = usageHistory.records.map({ Int($0.timeIntervalSince1970) })
//        return result
//    }
//}
