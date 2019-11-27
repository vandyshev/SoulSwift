import Foundation

private enum Constants {
    static let credential = "SOUL_SWIFT_CREDENTIAL"
    static let legacyUserIdKey = "SL/USER_ID"
    static let legacySessionTokenKey = "SL/SESSION_TOKEN"
    static let legacyServerTimeDeltaKey = "SL/SERVER_TIME_DELTA"
}

protocol StorageServiceProtocol {
    var credential: SoulCredential? { get set }
    @available(*, deprecated, message: "Используется для совместимости c SoulSDK и Dream")
    var legacyUserId: String? { get set }
    @available(*, deprecated, message: "Используется для совместимости c SoulSDK и Dream")
    var legacySessionToken: String? { get set }
    @available(*, deprecated, message: "Используется для совместимости c SoulSDK и Dream")
    var legacyServerTimeDelta: TimeInterval? { get set }
}

final class StorageService: StorageServiceProtocol {

    private let userDefaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    var credential: SoulCredential? {
        get {
            return fetchObject(for: Constants.credential)
        }
        set {
            if let value = newValue {
                save(object: newValue, for: Constants.credential)
            } else {
                removeObject(for: Constants.credential)
            }
        }
    }

    var legacyUserId: String? {
        get {
            userDefaults.string(forKey: Constants.legacyUserIdKey)
        } set {
            userDefaults.set(newValue, forKey: Constants.legacyUserIdKey)
        }
    }
    
    var legacySessionToken: String? {
        get {
            userDefaults.string(forKey: Constants.legacySessionTokenKey)
        } set {
            userDefaults.set(newValue, forKey: Constants.legacySessionTokenKey)
        }
    }

    var legacyServerTimeDelta: TimeInterval? {
        get {
            userDefaults.double(forKey: Constants.legacyServerTimeDeltaKey)
        } set {
            userDefaults.set(newValue, forKey: Constants.legacyServerTimeDeltaKey)
        }
    }

    private func save<Element>(object: Element, for key: String) where Element: Encodable {
        save(objects: [object], for: key)
    }

    private func save<Element>(objects: [Element], for key: String) where Element: Encodable {
        objects.forEach {
            let data = try? jsonEncoder.encode($0)
            userDefaults.set(data, forKey: key)
        }
    }

    private func removeObject(for key: String) {
        userDefaults.removeObject(forKey: key)
    }

    private func fetchObject<Element>(for key: String) -> Element? where Element: Decodable {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? jsonDecoder.decode(Element.self, from: data)
    }
}
