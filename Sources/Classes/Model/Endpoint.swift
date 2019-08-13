import Foundation

enum EndpointEntity: String {
    case recommendations = "/users/recommendations"
    case koth = "/blocks/soul/koth/"

    private static let allValues: [EndpointEntity] = [recommendations, koth]

    static func entity(_ url: String) -> EndpointEntity? {
        for value in allValues where value.rawValue == url {
            return value
        }
        return nil
    }
}

enum EndpointAction: Equatable {
    case new
    case unknown
}

struct Endpoint: Equatable {
    var entity: EndpointEntity
    var action: EndpointAction
}
