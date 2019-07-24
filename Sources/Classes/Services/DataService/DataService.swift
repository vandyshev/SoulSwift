import UIKit

protocol DateService: AnyObject {
    var adjustedUnixTimeStamp: UnixTimeStamp { get }
}

class DateServiceImpl: DateService {
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    var adjustedUnixTimeStamp: UnixTimeStamp {
        let delta = storage.serverTimeDelta ?? 0
        return DateHelper.currentUnixTimestamp + delta
    }
}
