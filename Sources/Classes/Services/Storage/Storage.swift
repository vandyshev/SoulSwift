import UIKit

protocol Storage {
    var userID: String? { get set }
    var sessionToken: String? { get set }
    var serverTimeDelta: Double? { get set }
}
