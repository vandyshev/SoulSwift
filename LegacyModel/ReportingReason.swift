enum ReportingReason: Equatable {
    case nude
    case bullying
    case spam
    case scam
    case sexMoney
    case other(String?)
    case noReason

//    var title: String {
//        switch self {
//        case .nude:
//            return Localization.Report.Reason.nude
//        case .bullying:
//            return Localization.Report.Reason.bullying
//        case .spam:
//            return Localization.Report.Reason.spam
//        case .scam:
//            return Localization.Report.Reason.scam
//        case .sexMoney:
//            return Localization.Report.Reason.sexMoney
//        case .other:
//            return Localization.Report.Reason.other
//        case .noReason:
//            return Localization.Report.Reason.noReason
//        }
//    }

    var code: String {
        switch self {
        case .nude:
            return "NUDE"
        case .bullying:
            return "BULLYING"
        case .spam:
            return "SPAM"
        case .scam:
            return "SCAM"
        case .sexMoney:
            return "SEX_MONEY"
        case .other:
            return "OTHER"
        case .noReason:
            return "NO_REASON"
        }
    }

    var comment: String? {
        switch self {
        case let .other(comment):
            return comment
        default:
            return nil
        }
    }

    static func feedReportingReasons() -> [ReportingReason] {
        return [.nude, .spam, .other("")]
    }

    static func chatListReportingReasons(_ gender: Gender) -> [ReportingReason] {
        switch gender {
        case .female:
            return [.bullying, .spam, .sexMoney, .scam, .other("")]
        case .male:
            return [.bullying, .spam, .scam, .other("")]
        default:
            return []
        }
    }

    static func chatRoomReportingReasons(_ gender: Gender) -> [ReportingReason] {
        switch gender {
        case .female:
            return [.bullying, .spam, .sexMoney, .scam, .other("")]
        case .male:
            return [.bullying, .spam, .scam, .other("")]
        default:
            return []
        }
    }
}

func == (a: ReportingReason, b: ReportingReason) -> Bool {
    return a.code == b.code
}
