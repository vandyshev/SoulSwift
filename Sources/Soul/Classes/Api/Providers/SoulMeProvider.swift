protocol SoulMeProviderProtocol {
    var meUpdated: ((MyUser) -> Void)? { get set }
    func updateMe(_ data: Data?)
}

private struct Response: Codable {
    let me: MyUser?
}

class SoulMeProvider: SoulMeProviderProtocol {

    var meUpdated: ((MyUser) -> Void)?

    private let decoder = JSONDecoder()

    private var me: MyUser? {
        didSet {
            me.map { meUpdated?($0) }
        }
    }

    func updateMe(_ data: Data?) {
        guard let data = data else { return }
        if let me = try? decoder.decode(Response.self, from: data).me {
            self.me = me
        }
    }

}
