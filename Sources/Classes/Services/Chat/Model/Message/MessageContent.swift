import Foundation

public enum MessageContent {
    case text(String)
    case photo(photoId: String, albumName: String)
    case location(latitude: Double, longitude: Double)
}
