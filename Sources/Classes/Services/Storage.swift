import UIKit

protocol Storage {

    var userID: String? { get set }
    var sessionToken: String? { get set }
    var serverTimeDelta: Double? { get set }
    
}

private enum Constants {
    static let prefixKey = "SL"
    static let userIDKey = "USER_ID"
    static let sessionIDKey = "SESSION_TOKEN"
    static let serverTimeDelta = "SERVER_TIME_DELTA"
}

class SoulSDKCommonStorage: Storage {
    private let internalStorage = UserDefaults.standard
    
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
    
    
    private func fixedKey(_ key: String) -> String {
        return "\(Constants.prefixKey)/\(key)"
    }
    
}
