import Foundation

struct ConsentModel {
    var consentGiven: Bool
    var consentText: String
    var consentContext: String
    var consentRequestText: String
    var consentGivenDate: Date
    var consentWithdrawn: Bool
    var consentWithdrawnDate: Date?
    var countryCodeForGivenConsent: String?
    var cityNameForGivenConsent: String?
}

extension ConsentModel {
    static func from(_ parameters: [AnyHashable: Any]) -> ConsentModel? {
        guard let consentGiven = parameters["consentGiven"] as? Bool,
            let consentText = parameters["consentText"] as? String,
            let consentContext = parameters["consentContext"] as? String,
            let consentRequestText = parameters["consentRequestText"] as? String,
            let consentGivenDate = Formatter.shared.date(object: parameters, name: "consentGivenDate"),
            let consentWithdrawn = parameters["consentWithdrawn"] as? Bool else { return nil }

        // this properties could be nil
        let consentWithdrawnDate = Formatter.shared.date(object: parameters, name: "consentWithdrawnDate")
        let countryCodeForGivenConsent = parameters["countryCodeForGivenConsent"] as? String
        let cityNameForGivenConsent = parameters["cityNameForGivenConsent"] as? String

        return ConsentModel(
            consentGiven: consentGiven,
            consentText: consentText,
            consentContext: consentContext,
            consentRequestText: consentRequestText,
            consentGivenDate: consentGivenDate,
            consentWithdrawn: consentWithdrawn,
            consentWithdrawnDate: consentWithdrawnDate,
            countryCodeForGivenConsent: countryCodeForGivenConsent,
            cityNameForGivenConsent: cityNameForGivenConsent
        )
    }

    static func to(_ consent: ConsentModel) -> [String: Any] {
        var result = [String: Any]()
        result["consentGiven"] = consent.consentGiven
        result["consentText"] = consent.consentText
        result["consentContext"] = consent.consentContext
        result["consentRequestText"] = consent.consentRequestText
        result["consentGivenDate"] = Formatter.shared.string(consent.consentGivenDate)

        result["consentWithdrawn"] = false
        result["consentWithdrawnDate"] = ""

        result["countryCodeForGivenConsent"] = consent.countryCodeForGivenConsent
        result["cityNameForGivenConsent"] = consent.cityNameForGivenConsent ?? ""
        return result
    }

    func validate() -> Bool {
        guard consentGiven else { return false }
        guard consentContext.count > 10 else { return false }
        guard consentRequestText.count > 5 else { return false }
        guard consentWithdrawn == false else { return false }
        guard consentWithdrawnDate == nil else { return false }
        guard countryCodeForGivenConsent != nil else { return false }
        return true
    }
}

enum ConsentType: String {
    case serviceRequiredDataGetPurev0001
}

//extension ConsentType {
//    static func from(_ parameters: [AnyHashable: Any]) -> [ConsentType: ConsentModel] {
//        guard let object = parameters[DomainKeys.consents.rawValue] as? [String: Any] else {
//            return [:]
//        }
//
//        let pairs = object.compactMap { entry -> (ConsentType, ConsentModel)? in
//            if let type = ConsentType(rawValue: entry.key),
//                let parameters = entry.value as? [AnyHashable: Any],
//                let model = ConsentModel.from(parameters) {
//                return (type, model)
//            }
//            return nil
//        }
//
//        return Dictionary(uniqueKeysWithValues: pairs)
//    }
//
//    static func to(_ consents: [ConsentType: ConsentModel]) -> [String: Any] {
//        let pairs = consents.map { entry -> (String, [String: Any]) in
//            return (entry.key.rawValue, ConsentModel.to(entry.value))
//        }
//
//        return Dictionary(uniqueKeysWithValues: pairs)
//    }
//}

private class Formatter {

    static let shared = Formatter()

    private let formatter = DateFormatter()

    private init() {
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
    }

    func date(object: [AnyHashable: Any], name: String) -> Date? {
        guard let value = object[name] as? String else {
            return nil
        }
        return formatter.date(from: value)
    }

    func string(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}
