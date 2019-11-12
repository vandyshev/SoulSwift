public struct Chat: Decodable {
    let id: String
    let myStatus: String?
    let participants: [Participant]?
    let expiresTime: TimeInterval?
    let channelName: String?
    let flags: Int?
    let creator: String?

    public struct Participant: Decodable {
        let userId: String?
        let status: String?
    }
}
