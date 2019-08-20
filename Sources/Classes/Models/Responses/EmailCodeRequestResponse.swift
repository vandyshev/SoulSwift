public struct EmailCodeRequestResponse: Decodable {
    let status: String
    let providerId: Int
    let additionalInfo: AdditionalInfo
}
