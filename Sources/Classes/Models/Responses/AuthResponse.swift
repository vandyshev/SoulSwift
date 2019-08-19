import Foundation

public struct AuthResponse: Decodable {
    let authorization: Authorization
    let additionalInfo: AdditionalInfo
}
