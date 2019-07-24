import UIKit
@testable import SoulSwift

class DateServiceMock: DateService {

    var adjustedUnixTimeStamp: UnixTimeStamp

    init(adjustedUnixTimeStamp: UnixTimeStamp) {
        self.adjustedUnixTimeStamp = adjustedUnixTimeStamp
    }
}
