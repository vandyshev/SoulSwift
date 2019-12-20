import UIKit

public struct SystemDataRepresentation: Equatable {
    public let type: String
    public let data: Data
    public init(type: String, data: Data) {
        self.type = type
        self.data = data
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

extension SystemDataRepresentation: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "t"
        case data = "d"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        let dictContainer = try container.nestedContainer(keyedBy: DictionaryCodingKeys.self, forKey: .data)
        let dict = dictContainer.decodeUnknownKeyValues()
        self.data = try JSONSerialization.data(withJSONObject: dict)
    }

    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        var dictContainer = try container.nestedContainer(keyedBy: DictionaryCodingKeys.self, forKey: .data)
        if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            try dictContainer.encodeUnknownValues(dict: dict)
        }
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
