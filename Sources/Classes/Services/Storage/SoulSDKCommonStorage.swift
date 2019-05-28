import Foundation

private enum Constants {
    static let prefixKey = "SL"
    static let userIDKey = "USER_ID"
    static let sessionIDKey = "SESSION_TOKEN"
    static let serverTimeDelta = "SERVER_TIME_DELTA"
    static let deviceIdentifierKey = "DEVICE_IDDENTIFIER"
}

final class SoulSDKCommonStorage {
    private let internalStorage = UserDefaults.standard

    private func fixedKey(_ key: String) -> String {
        return "\(Constants.prefixKey)/\(key)"
    }
}

/// This extension receives data from the SoulSDK storage
extension SoulSDKCommonStorage: Storage {

    var userID: String? {
        get {
            return internalStorage.string(forKey: fixedKey(Constants.userIDKey))
        }
        set {
            assertionFailure()
        }
    }

    var sessionToken: String? {
        get {
            return internalStorage.string(forKey: fixedKey(Constants.sessionIDKey))
        }
        set {
            assertionFailure()
        }
    }

    var serverTimeDelta: Double? {
        get {
            guard let serverTimeString = internalStorage.string(forKey: fixedKey(Constants.serverTimeDelta)) else {
                return nil
            }
            return Double(serverTimeString)
        }
        set {
            assertionFailure()
        }
    }
}

extension SoulSDKCommonStorage: DeviceIdStorage {
    var deviceID: String? {
        get {
            return internalStorage.string(forKey: fixedKey(Constants.deviceIdentifierKey))
        }
        set {
            internalStorage.set(newValue, forKey: fixedKey(Constants.deviceIdentifierKey))
        }
    }
}
