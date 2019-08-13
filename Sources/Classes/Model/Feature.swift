/// Application feature toggles
///
enum Feature {
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

enum GenderComboType: String {
    case maleFemale = "M_F"
    case femaleMale = "F_M"
    case femaleFemale = "F_F"
    case maleMale = "M_M"
}

enum PaygateType: String {
    case trial
    case notTrial
}
