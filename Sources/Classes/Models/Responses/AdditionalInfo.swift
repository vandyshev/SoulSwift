
public struct AdditionalInfo: Decodable {
    let serverTime: TimeInterval
    let clientCountryCode: String
    let clientCityName: String
    let clientLatitude: String
    let clientLongitude: String
    let isClientInEU: String
}
