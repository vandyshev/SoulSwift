import UIKit

extension Encodable {
    var asString: String? {
        guard let encodedData = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: encodedData, encoding: .utf8)
    }
}
