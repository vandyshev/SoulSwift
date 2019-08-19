import Foundation
struct ReviewCounters {
    var asked: Bool
    var received: Bool
    var declined: Bool

    var activeChatsInRequest: Set<String>
    var isLocationShared: Bool
    var activeChatsInMonth: Set<String>

    var requestCountInDay: Int
    var chatsInDay: Set<String>
    var isKothPurchased: Bool

    var isSubscriptionReactivated: Bool
    var likesCountInRequest: Int
    var isChatExpired: Bool

    var nextDay: Date?
    var nextMonth: Date?
    var timeout: Date?
}

//extension ReviewCounters {
//
//    var isHappy: Bool {
//        if activeChatsInRequest.count >= Config.ReviewCounters.activeChatsInRequest { return true }
//        if isLocationShared { return true }
//        if activeChatsInMonth.count >= Config.ReviewCounters.activeChatsInMonth { return true }
//        return false
//    }
//
//    var isPotentiallyHappy: Bool {
//        if isHappy { return false }
//        if requestCountInDay >= Config.ReviewCounters.requestCountInDay { return true }
//        if chatsInDay.count >= Config.ReviewCounters.chatsInDay { return true }
//        if isKothPurchased { return true }
//        return false
//    }
//
//    var isAccepted: Bool {
//        if likesCountInRequest >= Config.ReviewCounters.likesCountInRequest { return true }
//        if isSubscriptionReactivated { return true }
//        if isChatExpired { return true }
//        return false
//    }
//}

extension ReviewCounters {
    static func from(_ parameters: [AnyHashable: Any]) -> ReviewCounters {
        let asked = parameters["asked"] as? Bool ?? false
        let received = parameters["received"] as? Bool ?? false
        let declined = parameters["declined"] as? Bool ?? false

        let activeChatsInRequest = parameters["activeChatsInRequest"] as? [String] ?? []
        let isLocationShared = parameters["isLocationShared"] as? Bool ?? false
        let activeChatsInMonth = parameters["activeChatsInMonth"] as? [String] ?? []

        let requestCountInDay = parameters["requestCountInDay"] as? Int ?? 0
        let chatsInDay = parameters["chatsInDay"] as? [String] ?? []
        let isKothPurchased = parameters["isKothPurchased"] as? Bool ?? false

        let isSubscriptionReactivated = parameters["isSubscriptionReactivated"] as? Bool ?? false
        let likesCountInRequest = parameters["likesCountInRequest"] as? Int ?? 0
        let isChatExpired = parameters["isChatExpired"] as? Bool ?? false

        let nextDay = parameters["nextDay"] as? Int
        let nextMonth = parameters["nextMonth"] as? Int
        let timeout = parameters["timeout"] as? Int

        return ReviewCounters(
            asked: asked,
            received: received,
            declined: declined,
            activeChatsInRequest: Set(activeChatsInRequest),
            isLocationShared: isLocationShared,
            activeChatsInMonth: Set(activeChatsInMonth),
            requestCountInDay: requestCountInDay,
            chatsInDay: Set(chatsInDay),
            isKothPurchased: isKothPurchased,
            isSubscriptionReactivated: isSubscriptionReactivated,
            likesCountInRequest: likesCountInRequest,
            isChatExpired: isChatExpired,
            nextDay: Date(timeIntervalSince1970: TimeInterval(nextDay ?? 0)),
            nextMonth: Date(timeIntervalSince1970: TimeInterval(nextMonth ?? 0)),
            timeout: Date(timeIntervalSince1970: TimeInterval(timeout ?? 0))
        )
    }

    static func to(_ counters: ReviewCounters) -> [String: Any] {
        return [
            "asked": counters.asked,
            "received": counters.received,
            "declined": counters.declined,
            "activeChatsInRequest": Array(counters.activeChatsInRequest),
            "isLocationShared": counters.isLocationShared,
            "activeChatsInMonth": Array(counters.activeChatsInMonth),
            "requestCountInDay": counters.requestCountInDay,
            "chatsInDay": Array(counters.chatsInDay),
            "isKothPurchased": counters.isKothPurchased,
            "isSubscriptionReactivated": counters.isSubscriptionReactivated,
            "likesCountInRequest": counters.likesCountInRequest,
            "isChatExpired": counters.isChatExpired,
            "nextDay": Int(counters.nextDay?.timeIntervalSince1970 ?? 0),
            "nextMonth": Int(counters.nextMonth?.timeIntervalSince1970 ?? 0),
            "timeout": Int(counters.timeout?.timeIntervalSince1970 ?? 0)
        ]
    }
}
