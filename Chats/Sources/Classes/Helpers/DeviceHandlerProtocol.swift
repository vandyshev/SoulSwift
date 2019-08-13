import Foundation

protocol DeviceHandlerProtocol {
    var deviceIdentifier: String { get }
}

class DeviceHandler: DeviceHandlerProtocol {

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
