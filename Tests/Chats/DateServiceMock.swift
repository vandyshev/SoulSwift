import UIKit
@testable import SoulSwift

class DateServiceMock: DateService {
    private(set) var currentAdjustedUnixTimeStamp: UnixTimeStamp

    private let adjustedTimeStampFromDate: UnixTimeStamp
    func getAdjustedTimeStamp(from date: Date) -> UnixTimeStamp {
        return adjustedTimeStampFromDate
    }

    init(currentAdjustedUnixTimeStamp: UnixTimeStamp, adjustedTimeStampFromDate: UnixTimeStamp) {
        self.currentAdjustedUnixTimeStamp = currentAdjustedUnixTimeStamp
        self.adjustedTimeStampFromDate    = adjustedTimeStampFromDate
    }
}
