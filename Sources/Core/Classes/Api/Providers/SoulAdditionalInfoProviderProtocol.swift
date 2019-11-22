protocol SoulAdditionalInfoProviderProtocol {
    var additionalInfo: AdditionalInfo? { get }
    func saveAdditionalInfo(_ data: Data?)
}

private struct Response: Codable {
    let additionalInfo: AdditionalInfo?
}

class SoulAdditionalInfoProvider: SoulAdditionalInfoProviderProtocol {

    var additionalInfo: AdditionalInfo?

    private let decoder = JSONDecoder()

    func saveAdditionalInfo(_ data: Data?) {
        guard let data = data else { return }
        let response = try? decoder.decode(Response.self, from: data)
        additionalInfo = response?.additionalInfo
    }
}
