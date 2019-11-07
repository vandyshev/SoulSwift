import Foundation

public struct MyUser: Codable {
    // TODO: SoulSwift: Rename to id
    public let id: String
//    public let mainPhotoUrl: URL?
//    public let photoId: String?
       // TODO: SoulSwift: Change gender
    public let gender: Gender = .male
//    public let lookingFor: Gender
//    public let expiration: Double
//    public let reactions: Reactions
//    public let coordinate: Coordinates
//    public let dateCreated: Date?
//    public let pushToken: String?
    public let distinctId: String? = nil
//    public let canCall: Bool
//    public let privates: Privates?
//    public let filtarable: Filterable?
//    public let ipCoordinates: Coordinates?

    enum CodingKeys: String, CodingKey {
        case id
//        case gender
    }
}

public extension MyUser {
//    private func age() -> Int {
//        let expirationDate = Date(timeIntervalSince1970: expiration)
//
//        if let created = Calendar.current.date(byAdding: .hour, value: -1, to: expirationDate) {
//            let age = Date().timeIntervalSince(created)
//
//            return Int(age)
//        }
//
//        return 0
//    }

//    func requestAnalyticsData() -> RequestEventData {
//        return RequestEventData(requestId: privates?.availabilitySessionId ?? "", age: age())
//    }

//    func genderCombo() -> GenderComboType? {
//        var genderCombo: GenderComboType?
//
//        switch gender {
//        case .male:
//            switch lookingFor {
//            case .male:
//                genderCombo = .maleMale
//            case .female:
//                genderCombo = .maleFemale
//            default:
//                break
//            }
//        case .female:
//            switch lookingFor {
//            case .male:
//                genderCombo = .femaleMale
//            case .female:
//                genderCombo = .femaleFemale
//            default:
//                break
//            }
//        default:
//            break
//        }
//
//        return genderCombo
//    }
//
//    var hasPhoto: Bool {
//        return mainPhotoUrl != nil && photoId != nil
//    }

//    var isExpired: Bool {
//        print(expiration - Date.now().timeIntervalSince1970)
//        return expiration < Date.now().timeIntervalSince1970
//    }
}

enum IntentStatus {
    case active, closed, deleted
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

public struct Privates {
    var af_submitTracked: Bool
    var af_chatTracked: Bool
    var af_mfLikeTracked: Bool
    var af_fmLikeTracked: Bool
    var af_mmLikeTracked: Bool
    var af_ffLikeTracked: Bool
    var availabilitySessionId: String?
//    var soulSettings: SoulSettings?
//    var usageHistory: UsageHistory?
    var deepestFunnelScreen: FunnelScreen?
    var chatCounter: Int
//    var specialProposalProduct: SpecialProposalProduct?
//    var consents: [ConsentType: ConsentModel]
    var fakeLocation: Coordinates?
    var isAgreeToReceiveNews: Bool
}

extension Privates {
    static func empty() -> Privates {
        return Privates(af_submitTracked: false,
                        af_chatTracked: false,
                        af_mfLikeTracked: false,
                        af_fmLikeTracked: false,
                        af_mmLikeTracked: false,
                        af_ffLikeTracked: false,
                        availabilitySessionId: nil,
//                        soulSettings: nil,
//                        usageHistory: nil,
                        deepestFunnelScreen: nil,
                        chatCounter: 0,
//                        specialProposalProduct: nil,
//                        consents: [:],
                        fakeLocation: nil,
                        isAgreeToReceiveNews: false)
    }
}

public struct Filterable {
}
