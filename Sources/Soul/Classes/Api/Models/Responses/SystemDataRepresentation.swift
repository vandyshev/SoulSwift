import UIKit

public struct SystemDataRepresentation: Equatable {
    public let type: String
    public let data: Data
    public init(type: String, data: Data) {
        self.type = type
        self.data = data
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
        assertionFailure()
    }
}
