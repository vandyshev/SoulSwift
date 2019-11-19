import Foundation

private enum Constants {
    static let credential = "SOUL_SWIFT_CREDENTIAL"
    static let legacyUserIdKey = "SL/USER_ID"
    static let legacySessionTokenKey = "SL/SESSION_TOKEN"
}

private enum StorageServiceError: LocalizedError {
    case wrongKeyType

    var errorDescription: String? {
        switch self {
        case .wrongKeyType:
            return "Wrong key type, please use String only"
        }
    }
}

protocol StorageServiceProtocol {
    var credential: SoulCredential? { get set }
    @available(*, deprecated, message: "Используется для совместимости c SoulSDK и Dream")
    var legacyUserId: String? { get set }
    @available(*, deprecated, message: "Используется для совместимости c SoulSDK и Dream")
    var legacySessionToken: String? { get set }
}

final class StorageService: StorageServiceProtocol {

    private let userDefaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    var credential: SoulCredential? {
        get {
            return try? fetchObject(for: Constants.credential)
        }
        set {
            try? save(object: newValue, for: Constants.credential)
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

    private func save<Key, Element>(object: Element, for key: Key) throws where Key: Hashable, Element: Encodable {
        try save(objects: [object], for: key)
    }

    private func save<Key, Element>(objects: [Element], for key: Key) throws where Key: Hashable, Element: Encodable {
        try objects.forEach {
            let data = try jsonEncoder.encode($0)
            guard let stringKey = key as? String else {
                throw StorageServiceError.wrongKeyType
            }
            userDefaults.set(data, forKey: stringKey)
        }
    }

    private func fetchObject<Key, Element>(for key: Key) throws -> Element where Key: Hashable, Element: Decodable {
        guard let stringKey = key as? String else {
            throw StorageServiceError.wrongKeyType
        }

        guard let data = userDefaults.data(forKey: stringKey) else {
            throw StorageServiceError.wrongKeyType
        }

        return try jsonDecoder.decode(Element.self, from: data)
    }
}
