import Foundation

struct Features: Decodable {
    let features: [Feature]

    enum CodingKeys: String, CodingKey {
        case features
    }

    enum FeaturesCodingKeys: String, CodingKey {
        case soulChat = "use_soul_chats"
        case chainReaction
        case kingOfTheHill = "king_of_the_hill"
    }

    enum EnabledCodingKeys: String, CodingKey {
        case enabled
        case chainReactionEnabled
    }

    init(from decoder: Decoder) throws {
        var features: [Feature] = []
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let featuresContainer = try container.nestedContainer(keyedBy: FeaturesCodingKeys.self, forKey: .features)

        if let enabledContainer = try? featuresContainer.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .soulChat),
            let enabled = try? enabledContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.soulChat(enabled))
        }

        if let enabledContainer = try? featuresContainer.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .chainReaction),
            let enabled = try? enabledContainer.decode(Bool.self, forKey: .chainReactionEnabled) {
            features.append(Feature.chainReaction(enabled))
        }

        if let enabledContainer = try? featuresContainer.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .kingOfTheHill),
            let enabled = try? enabledContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.kingOfTheHill(enabled))
        }

        self.features = features
    }
}

public enum Feature {
    case chainReaction(Bool)
    case audioCall(Bool, [GenderComboType])
    case kingOfTheHill(Bool)
    case freeToPlayLimits(Bool)
    case reviewRequest(Bool)
    case clientCountryCode(String)
    case clientCityName(String)
    case sentry(Bool)
    case paygateType(PaygateType)
    case searchRadius(Int)
    case newUserLoadingStrategy(Bool)
    case soulChat(Bool)
    case instantChat(Bool)
    case instantChatOnboarding(Bool)
    case chatCaching(Bool)
    case sleepingStatsNotifications(Bool)
    case requestDuration(UInt)

    var isChainReachable: Bool {
        guard case .chainReaction = self else { return false }
        return true
    }

    var isAudioCall: Bool {
        guard case .audioCall = self else { return false }
        return true
    }

    var isKingOfTheHill: Bool {
        guard case .kingOfTheHill = self else { return false }
        return true
    }

    var isInstantChat: Bool {
        guard case .instantChat = self else { return false }
        return true
    }

    var isInstantChatOnboarding: Bool {
        guard case .instantChatOnboarding = self else { return false }
        return true
    }

    var isFreeToPlayLimits: Bool {
        guard case .freeToPlayLimits = self else { return false }
        return true
    }

    var isReviewRequest: Bool {
        guard case .reviewRequest = self else { return false }
        return true
    }

    var isClientCountryCode: Bool {
        guard case .clientCountryCode = self else { return false }
        return true
    }

    var isClientCityName: Bool {
        guard case .clientCityName = self else { return false }
        return true
    }

    var isSentry: Bool {
        guard case .sentry = self else { return false }
        return true
    }

    var isPaygateType: Bool {
        guard case .paygateType = self else { return false}
        return true
    }

    var isSearchRadius: Bool {
        guard case .searchRadius = self else { return false }
        return true
    }

    var isNewUserLoadingStrategy: Bool {
        guard case .newUserLoadingStrategy = self else { return false }
        return true
    }

    var isSoulChat: Bool {
        guard case .soulChat = self else { return false }
        return true
    }

    var isSleepingStatsNotifications: Bool {
        guard case .sleepingStatsNotifications = self else { return false }
        return true
    }

    var isRequestDuration: Bool {
        guard case .requestDuration = self else { return false }
        return true
    }

    var isChatCaching: Bool {
        guard case .chatCaching = self else { return false }
        return true
    }
}

public enum GenderComboType: String {
    case maleFemale = "M_F"
    case femaleMale = "F_M"
    case femaleFemale = "F_F"
    case maleMale = "M_M"
}

public enum PaygateType: String {
    case trial
    case notTrial
}
