import UIKit

public typealias UnixTimeStamp = Int

class DateHelper {
    static var currentUnixTimestamp: UnixTimeStamp {
        return Int(round(Date().timeIntervalSince1970))
    }
}
