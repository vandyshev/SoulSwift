import UIKit
@testable import SoulSwift

class FakeStorage: Storage {

    var userID: String?
    var sessionToken: String?
    var serverTimeDelta: Double?

    init(userID: String?, sessionToken: String?, serverTimeDelta: Double?) {

        self.userID = userID
        self.sessionToken = sessionToken
        self.serverTimeDelta = serverTimeDelta
    }
}
