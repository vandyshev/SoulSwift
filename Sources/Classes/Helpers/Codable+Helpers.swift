import UIKit

extension Encodable {
    var asString: String? {
        guard let encodedData = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: encodedData, encoding: .utf8)
    }

    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct DictionaryCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

extension KeyedDecodingContainer where Key == DictionaryCodingKeys {
    func decodeUnknownKeyValues() -> [String: Any] {
        var data = [String: Any]()

        for key in allKeys {
            if let value = try? decode(String.self, forKey: key) {
                data[key.stringValue] = value
            } else if let value = try? decode(Bool.self, forKey: key) {
                data[key.stringValue] = value
            } else if let value = try? decode(Int.self, forKey: key) {
                data[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                data[key.stringValue] = value
            } else if let value = try? decode(Float.self, forKey: key) {
                data[key.stringValue] = value
            } else {
                if let nested = try? nestedContainer(keyedBy: DictionaryCodingKeys.self, forKey: key) {
                    data[key.stringValue] = nested.decodeUnknownKeyValues()
                }
            }
        }
        return data
    }
}
