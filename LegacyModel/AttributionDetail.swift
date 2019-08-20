import Foundation
struct AttributionDetail {
    static let iadAdgroupId = "iad-adgroup-id"
    static let iadAdgroupName = "iad-adgroup-name"
    static let iadAttribution = "iad-attribution"
    static let iadCampaignId = "iad-campaign-id"
    static let iadCampaignName = "iad-campaign-name"
    static let iadClickDate = "iad-click-date"
    static let iadConversionDate = "iad-conversion-date"
    static let iadCreativeId = "iad-creative-id"
    static let iadCreativeName = "iad-creative-name"
    static let iadKeyword = "iad-keyword"
    static let iadLineitemId = "iad-lineitem-id"
    static let iadLineitemName = "iad-lineitem-name"
    static let iadOrgName = "iad-org-name"

    static let defaultCampaignName = "CampaignName"
    static func date(value: String) -> Date? {
        return Formatter.shared.date(value: value)
    }

    private class Formatter {
        static let shared = Formatter()
        private let formatter = DateFormatter()

        private init() {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm.ss'Z"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        }

        func date(value: String) -> Date? {
            return formatter.date(from: value)
        }
    }
}
