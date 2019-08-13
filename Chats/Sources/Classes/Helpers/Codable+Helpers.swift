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
