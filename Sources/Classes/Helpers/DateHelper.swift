import UIKit

public typealias UnixTimeStamp = Double

class DateHelper {
    static var currentUnixTimestamp: UnixTimeStamp {
        return Date().timeIntervalSince1970
    }
}
