import UIKit

public typealias UnixTimeStamp = Double

extension UnixTimeStamp {
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
}

class DateHelper {
    static var currentUnixTimestamp: UnixTimeStamp {
        return timestamp(from: Date())
    }

    static func timestamp(from date: Date) -> UnixTimeStamp {
        return date.timeIntervalSince1970
    }
}
