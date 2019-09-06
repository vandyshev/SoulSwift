import UIKit

protocol Storage: AnyObject {
    var userID: String? { get set }
    var sessionToken: String? { get set }
    var serverTimeDelta: Double? { get set }
}

protocol DeviceIdStorage: AnyObject {
    var deviceID: String? { get set }
}
