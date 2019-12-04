protocol SoulDateProviderProtocol {
    var currentAdjustedDate: Date { get }
    func updateServerTimeDelta(_ data: Data?)
}

private struct Response: Codable {
    let additionalInfo: AdditionalInfo?
}

class SoulDateProvider: SoulDateProviderProtocol {

    private let decoder = JSONDecoder()
    private var storageService: StorageServiceProtocol
    private var serverTimeDelta: TimeInterval?

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    var currentAdjustedDate: Date {
        guard let delta = serverTimeDelta ?? storageService.legacyServerTimeDelta else {
            return Date()
        }
        return Date().addingTimeInterval(delta)
    }

    func updateServerTimeDelta(_ data: Data?) {
        guard let data = data else { return }
        guard let serverTime = try? decoder.decode(Response.self, from: data).additionalInfo?.serverTime else { return }
        let nowTime = Date().timeIntervalSince1970
        let delta = serverTime - nowTime
        serverTimeDelta = delta
        storageService.legacyServerTimeDelta = delta
    }
}
