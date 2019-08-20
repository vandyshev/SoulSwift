
private enum Constants {
    static let userIdKey = "SOUL_SWIFT_USER_ID"
    static let sessionTokenKey = "SOUL_SWIFT_SESSION_TOKEN"
}

public protocol StorageServiceProtocol: AnyObject {
    var userId: String? { get set }
    var sessionToken: String? { get set }
}

final class StorageService: StorageServiceProtocol {

    private let internalStorage = UserDefaults.standard

    var userId: String? {
        get {
            return internalStorage.string(forKey: Constants.userIdKey)
        }
        set {
            internalStorage.set(newValue, forKey: Constants.userIdKey)
        }
    }

    var sessionToken: String? {
        get {
            return internalStorage.string(forKey: Constants.sessionTokenKey)
        }
        set {
            internalStorage.set(newValue, forKey: Constants.sessionTokenKey)
        }
    }
}
