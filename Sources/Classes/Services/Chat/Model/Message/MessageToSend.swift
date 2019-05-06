import Foundation

public enum MessageToSend {
    case text(String)
    case photo(photoId: String, albumName: String)
    case location(latitude: Double, longitude: Double)
}
