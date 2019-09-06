public struct PhoneRequestResponse: Decodable {
    let status: String
    let providerId: Int
    let additionalInfo: AdditionalInfo
}
