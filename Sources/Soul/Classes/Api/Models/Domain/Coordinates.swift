public struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
    var date: Date
}

extension Coordinates {
    static var defaultIntentCoordinates: Coordinates {
        return Coordinates(latitude: 0, longitude: 0, date: Date())
    }
}

extension Coordinates {
    var isZeroCoordinates: Bool {
        return latitude == 0 && longitude == 0
    }
}

struct Place {
    var city: String?
    var country: String?
}
