private enum Constants {
    static let credential = "SOUL_SWIFT_CREDENTIAL"
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

    private func fetchObject<Key, Element>(for key: Key) throws -> Element? where Key: Hashable, Element: Decodable {
        guard let stringKey = key as? String else {
            throw StorageServiceError.wrongKeyType
        }

        guard let data = userDefaults.data(forKey: stringKey) else {
            return nil
        }

        return try jsonDecoder.decode(Element.self, from: data)
    }
}
