import UIKit

protocol DateService: AnyObject {
    var currentAdjustedUnixTimeStamp: UnixTimeStamp { get }
    func getAdjustedTimeStamp(from date: Date) -> UnixTimeStamp
}

class DateServiceImpl: DateService {
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    var currentAdjustedUnixTimeStamp: UnixTimeStamp {
        return getAdjustedTimeStamp(from: Date())
    }

    func getAdjustedTimeStamp(from date: Date) -> UnixTimeStamp {
        let delta = storage.serverTimeDelta ?? 0
        let currentUnixTimestamp = DateHelper.timestamp(from: date)
        return currentUnixTimestamp + delta
    }
}
