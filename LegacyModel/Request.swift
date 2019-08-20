import Foundation

enum IntentStatus {
    case active, closed, deleted
}

struct Request {
    var userId: String
    var mainPhotoUrl: URL?
    var photoId: String?
    var gender: Gender
    var lookingFor: Gender
    var expiration: Double
//    var likeReaction: LikeReaction
    var coordinate: Coordinates
    var dateCreated: Date?
    var pushToken: String?
    var distinctId: String?
    var canCall: Bool
    var privates: Privates?
    var filtarable: Filterable?
    var ipCoordinates: Coordinates?

    /// Seconds from submit
    ///
    /// - Returns: Seconds from request being submitted
    fileprivate func age() -> Int {
        let expirationDate = Date(timeIntervalSince1970: expiration)

        if let created = Calendar.current.date(byAdding: .hour, value: -1, to: expirationDate) {
            let age = Date().timeIntervalSince(created)

            return Int(age)
        }

        return 0
    }

//    func requestAnalyticsData() -> RequestEventData {
//        return RequestEventData(requestId: privates?.availabilitySessionId ?? "", age: age())
//    }

    func genderCombo() -> GenderComboType? {
        var genderCombo: GenderComboType?

        switch gender {
        case .male:
            switch lookingFor {
            case .male:
                genderCombo = .maleMale
            case .female:
                genderCombo = .maleFemale
            default:
                break
            }
        case .female:
            switch lookingFor {
            case .male:
                genderCombo = .femaleMale
            case .female:
                genderCombo = .femaleFemale
            default:
                break
            }
        default:
            break
        }

        return genderCombo
    }
}

struct ReceiveNotifications {
    var reaction: Bool
    var chat: Bool
    var sleepingStats: Bool
}

struct SoulSettings {
    var receiveNotifications: ReceiveNotifications
}

enum FunnelScreen: String {
    case request = "Request Screen"
    case paygate = "Paygate Screen"
    case feed = "Feed Screen"
    case chat = "Chat Screen"

    static let order: [FunnelScreen] = [.request, .paygate, .feed, .chat]
}

struct Privates {
    var availabilitySessionId: String?
    var soulSettings: SoulSettings?
    var usageHistory: UsageHistory?
    var deepestFunnelScreen: FunnelScreen?
    var chatCounter: Int
    var specialProposalProduct: SpecialProposalProduct?
    var consents: [ConsentType: ConsentModel]
    var fakeLocation: Coordinates?
    var isAgreeToReceiveNews: Bool
}

extension Privates {
    static func empty() -> Privates {
        return Privates(availabilitySessionId: nil,
                        soulSettings: nil,
                        usageHistory: nil,
                        deepestFunnelScreen: nil,
                        chatCounter: 0,
                        specialProposalProduct: nil,
                        consents: [:],
                        fakeLocation: nil,
                        isAgreeToReceiveNews: false)
    }
}

struct Filterable {
    var chainReactionEnabled: Bool
}

enum RequestAuthType: Int {
    case verified = 200
    case new = 201
}
