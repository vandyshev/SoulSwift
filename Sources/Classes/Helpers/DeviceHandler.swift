import Foundation

protocol DeviceHandler {
    var deviceIdentifier: String { get }
}

class DeviceHandlerImpl: DeviceHandler {

    private let storage: DeviceIdStorage

    init(storage: DeviceIdStorage) {
        self.storage = storage
    }

    var deviceIdentifier: String {
        if let deviceID = storage.deviceID {
            return deviceID
        } else {
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
                                ?? UUID().uuidString
            storage.deviceID = deviceID
            return deviceID
        }
    }
}
