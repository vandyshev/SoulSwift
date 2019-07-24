import UIKit

public typealias UnixTimeStamp = Double

extension UnixTimeStamp {
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
}

class DateHelper {

    static func timestamp(from date: Date) -> UnixTimeStamp {
        return date.timeIntervalSince1970
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
