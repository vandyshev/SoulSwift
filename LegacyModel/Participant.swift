import Foundation

enum ParticipantStatus: String {
    case unknown = ""
    case active = "active"
    case escape = "deleted"
}

struct Participant {
    var userId: String
    var status: ParticipantStatus
}
