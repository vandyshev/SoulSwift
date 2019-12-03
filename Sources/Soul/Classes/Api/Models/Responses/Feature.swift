public enum Feature {
    case kingOfTheHill(Bool)
    case reviewRequest(Bool)
    case sentry(Bool)
    case searchRadius(Int)
    case instantChat(Bool, InstantChatPaygateType)
    case instantChatOnboarding(Bool)
    case chatCaching(Bool)
    case sleepingStatsNotifications(Bool)
    case endlessRequest(Bool)
    case resubmitThreshold(Int)
    case contactList(Bool)
    case isSubscriptionOffers(Bool)
    case subscriptionOffersTimeout(Int)
    case incomingLikesOnChats([GenderComboType])
    case keepCardsInFeed([GenderComboType])
    case subscriptionPaygateVersion(SubscriptionPaygateVersion)
    case localPushes(Bool)
    case showRestorePurchases(Bool)
}

public enum GenderComboType: String, Decodable {
    case maleFemale = "M_F"
    case femaleMale = "F_M"
    case femaleFemale = "F_F"
    case maleMale = "M_M"
}

public enum PaygateType: String, Decodable {
    case trial
    case notTrial
}

public enum SubscriptionPaygateVersion: String, Decodable {
    case version1
    case version2
    case version3
}

public enum InstantChatPaygateType: String, Decodable {
    case legacy
    case animated

    public var isAnimatedPaygate: Bool {
        return self == .animated
    }
}

struct Features: Decodable {
    let features: [Feature]

    enum CodingKeys: String, CodingKey {
        case kingOfTheHill = "king_of_the_hill"
        case reviewRequest = "review_request"
        case sentry = "sentry"
        case searchRadius = "recommendations_radius"
        case instantChatPaygate = "instant_chat_paygate"
        case chatCaching = "chat_caching"
        case sleepingStatsNotifications = "sleeping_stats_notifications"
        case instantChatOnboarding = "instant_chat_onboarding"
        case endlessRequest = "endless_request"
        case contactList = "contact_list"
        case incomingLikesOnChats = "incoming_likes_on_chats"
        case subscriptionOffers = "subscription_offers"
        case keepCardsInFeed = "keep_cards_in_feed"
        case subscriptionPaygateVersion = "paygate_variant"
        case localPushes = "local_pushes"
        case showRestorePurchases = "show_restore_purchases"
    }

    enum NestedCodingKeys: String, CodingKey {
        case enabled
        case radiusKm
        case resubmitThreshold = "resubmit_threshold"
        case genderCombo = "gender_combo"
        case paygateType = "paygate_type"
        case timeout
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    init(from decoder: Decoder) throws {
        var features: [Feature] = []
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .kingOfTheHill),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.kingOfTheHill(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .reviewRequest),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.reviewRequest(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .sentry),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.sentry(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .searchRadius),
            let radius = try? nestedContainer.decode(Int.self, forKey: .radiusKm) {
            features.append(Feature.searchRadius(radius))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .instantChatPaygate),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled),
            let paygateType = try? nestedContainer.decode(InstantChatPaygateType.self, forKey: .paygateType) {
            features.append(Feature.instantChat(enabled, paygateType))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .chatCaching),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.chatCaching(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .sleepingStatsNotifications),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.sleepingStatsNotifications(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .instantChatOnboarding),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.instantChatOnboarding(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .endlessRequest) {
            if let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
                features.append(Feature.endlessRequest(enabled))
            }
            if let resubmitThreshold = try? nestedContainer.decode(Int.self, forKey: .resubmitThreshold) {
                features.append(Feature.resubmitThreshold(resubmitThreshold))
            }
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .contactList) {
            if let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
                features.append(Feature.contactList(enabled))
            }
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .incomingLikesOnChats) {
            if let genderCombo = try? nestedContainer.decode([GenderComboType].self, forKey: .genderCombo) {
                features.append(Feature.incomingLikesOnChats(genderCombo))
            }
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .subscriptionOffers) {
            if let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
                features.append(Feature.isSubscriptionOffers(enabled))
            }
            if let timeout = try? nestedContainer.decode(Int.self, forKey: .timeout) {
                features.append(Feature.subscriptionOffersTimeout(timeout))
            }
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .keepCardsInFeed) {
            if let genderCombo = try? nestedContainer.decode([String].self, forKey: .genderCombo) {
                let genderCombo = genderCombo.compactMap { GenderComboType(rawValue: $0) }
                features.append(Feature.keepCardsInFeed(genderCombo))
            }
        }

        if let version = try? container.decode(SubscriptionPaygateVersion.self, forKey: .subscriptionPaygateVersion) {
            features.append(Feature.subscriptionPaygateVersion(version))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .localPushes),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.localPushes(enabled))
        }

        if let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .showRestorePurchases),
            let enabled = try? nestedContainer.decode(Bool.self, forKey: .enabled) {
            features.append(Feature.showRestorePurchases(enabled))
        }

        self.features = features
    }
}
