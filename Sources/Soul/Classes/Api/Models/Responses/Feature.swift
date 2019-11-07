// TODO: Закончить decoder
struct Features: Decodable {
    let features: [Feature]

    enum CodingKeys: String, CodingKey {
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

        if let enabledContainer = try? container.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .soulChat),
            let enabled = try? enabledContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.soulChat(enabled))
        }

        if let enabledContainer = try? container.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .chainReaction),
            let enabled = try? enabledContainer.decode(Bool.self, forKey: .chainReactionEnabled) {
            features.append(Feature.chainReaction(enabled))
        }

        if let enabledContainer = try? container.nestedContainer(keyedBy: EnabledCodingKeys.self, forKey: .kingOfTheHill),
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

public enum SubscriptionPaygateVersion: String {
    case version1
    case version2
    case version3
}

public enum InstantChatPaygateType: String {
    case legacy
    case animated

    public var isAnimatedPaygate: Bool {
        return self == .animated
    }
}

//class func featureMapper() -> DomainMapper<[AnyHashable: Any]?, [Feature]?> {
//        return DomainMapper<[AnyHashable: Any]?, [Feature]?> { source in
//            guard let features = source?["features"] as? [String: Any] else { return nil }
//
//            var mappedFeatures = [Feature]()
//
//            if let kingOfTheHillFeature = features[Config.Features.kingOfTheHill.rawValue] as? NSDictionary,
//                let enabled = kingOfTheHillFeature["enabled"] as? Bool {
//                mappedFeatures.append(Feature.kingOfTheHill(enabled))
//            }
//
//            if let instantChatFeature = features[Config.Features.instantChatPaygate.rawValue] as? [String: Any],
//                let enabled = instantChatFeature["enabled"] as? Bool,
//                let paygateType = instantChatFeature["paygate_type"] as? String,
//                let instantChatType = InstantChatPaygateType(rawValue: paygateType) {
//                    mappedFeatures.append(Feature.instantChat(enabled, instantChatType))
//            }
//
//            if let reviewRequest = features[Config.Features.reviewRequest.rawValue] as? NSDictionary,
//                let enabled = reviewRequest["enabled"] as? Bool {
//                mappedFeatures.append(Feature.reviewRequest(enabled))
//            }
//
//            if let info = source?["additionalInfo"] as? [String: Any],
//                let clientCountryCode = info["clientCountryCode"] as? String,
//                let clientCityName = info["clientCityName"] as? String {
//                mappedFeatures.append(Feature.clientCountryCode(clientCountryCode))
//                mappedFeatures.append(Feature.clientCityName(clientCityName))
//            }
//
//            if let sentryFeature = features[Config.Features.sentry.rawValue] as? NSDictionary,
//                let enabled = sentryFeature["enabled"] as? Bool {
//                mappedFeatures.append(Feature.sentry(enabled))
//            }
//
//            if let searchRadiusObject = features[Config.Features.searchRadius.rawValue] as? [String: Int],
//                let searchRadius = searchRadiusObject[Constants.searchRadiusKey] {
//                mappedFeatures.append(.searchRadius(searchRadius))
//            }
//
//            let sleepingStats = Config.Features.sleepingStatsNotifications.rawValue
//            if let sleepingStatsNotifications = features[sleepingStats] as? [String: Bool],
//               let value = sleepingStatsNotifications["enabled"] {
//                mappedFeatures.append(.sleepingStatsNotifications(value))
//            }
//
//            let instantChatOnboardingKey = Config.Features.instantChatOnboarding.rawValue
//            if let isInstantOnboarding = features[instantChatOnboardingKey] as? [String: Bool],
//                let value = isInstantOnboarding["enabled"] {
//                mappedFeatures.append(.instantChatOnboarding(value))
//            }
//
//            let chatCachingKey = Config.Features.chatCaching.rawValue
//            if let isChatCaching = features[chatCachingKey] as? [String: Bool],
//                let value = isChatCaching["enabled"] {
//                mappedFeatures.append(.chatCaching(value))
//            }
//
//            if let duration = features[Config.Features.requestDuration.rawValue] as? UInt {
//                mappedFeatures.append(.requestDuration(duration))
//            }
//
//            let endlessRequestKey = Config.Features.endlessRequest.rawValue
//            if let endlessRequest = features[endlessRequestKey] as? [String: Any],
//                let value = endlessRequest["enabled"] as? Bool {
//                mappedFeatures.append(.endlessRequest(value))
//                if let resubmitThreshold = endlessRequest["resubmit_threshold"] as? Int {
//                     mappedFeatures.append(.resubmitThreshold(resubmitThreshold))
//                }
//            }
//
//            let contactListKey = Config.Features.contactList.rawValue
//            if let contactList = features[contactListKey] as? [String: Any],
//                let value = contactList["enabled"] as? Bool {
//                mappedFeatures.append(.contactList(value))
//            }
//
//            let incomingLikesOnChatsKey = Config.Features.incomingLikesOnChats.rawValue
//            if let contactList = features[incomingLikesOnChatsKey] as? [String: Any],
//                let value = contactList[Constants.genderCombo] as? [String] {
//                let combos = value.compactMap { GenderComboType(rawValue: $0) }
//                mappedFeatures.append(.incomingLikesOnChats(combos))
//            }
//
//            let keepCardsKey = Config.Features.keepCardsInFeed.rawValue
//            if let keepCards = features[keepCardsKey] as? [String: Any],
//                let value = keepCards[Constants.genderCombo] as? [String] {
//                let combos = value.compactMap { GenderComboType(rawValue: $0) }
//                mappedFeatures.append(.keepCardsInFeed(combos))
//            }
//
//            let subscriptionOffersKey = Config.Features.subscriptionOffers.rawValue
//            if let subscriptionOffers = features[subscriptionOffersKey] as? [String: Any],
//                let value = subscriptionOffers["enabled"] as? Bool {
//                mappedFeatures.append(.isSubscriptionOffers(value))
//                if let timeout = subscriptionOffers["timeout"] as? Int {
//                     mappedFeatures.append(.subscriptionOffersTimeout(timeout))
//                }
//            }
//
//            if let subscriptionPaygateVersion = features[Config.Features.subscriptionPaygateVersion.rawValue] as? String,
//                let version = SubscriptionPaygateVersion(rawValue: subscriptionPaygateVersion) {
//                mappedFeatures.append(.subscriptionPaygateVersion(version))
//            }
//
//            let localPushesKey = Config.Features.localPushes.rawValue
//            if let localPushes = features[localPushesKey] as? [String: Any],
//                let value = localPushes["enabled"] as? Bool {
//                mappedFeatures.append(.localPushes(value))
//            }
//
//            return mappedFeatures
//        }
//    }
