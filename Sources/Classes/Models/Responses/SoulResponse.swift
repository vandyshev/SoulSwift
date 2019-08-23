public struct SoulResponse: Decodable {
    let authorization: Authorization
    let additionalInfo: AdditionalInfo
    let me: MyUser
}
