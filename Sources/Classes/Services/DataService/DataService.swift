import UIKit

protocol DateServiceProtocol: AnyObject {
    var currentAdjustedUnixTimeStamp: UnixTimeStamp { get }
    func getAdjustedTimeStamp(from date: Date) -> UnixTimeStamp
}

final class DateService: DateServiceProtocol {
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
