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

extension KeyedEncodingContainer where Key == DictionaryCodingKeys {
    mutating func encodeUnknownValues(dict: [String: Any]) throws {
        try dict.forEach {
            guard let codingKey = DictionaryCodingKeys(stringValue: $0.key) else {
                return
            }
            if let stringValue = $0.value as? String {
                try self.encode(stringValue, forKey: codingKey)
            } else if let intValue = $0.value as? Int {
                try self.encode(intValue, forKey: codingKey)
            } else if let boolValue = $0.value as? Bool {
                try self.encode(boolValue, forKey: codingKey)
            } else if let doubleValue = $0.value as? Double {
                try self.encode(doubleValue, forKey: codingKey)
            } else if let floatValue = $0.value as? Float {
                try self.encode(floatValue, forKey: codingKey)
            }
        }
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
