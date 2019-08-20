struct AppBundle {
    var name: String
    var description: String
    var order: Int
    var hasTrial: Bool
    var purchaseCount: Int
    var products: [SoulProduct]
}

extension AppBundle: Hashable {

    static func == (a: AppBundle, b: AppBundle) -> Bool {
        return a.name == b.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
