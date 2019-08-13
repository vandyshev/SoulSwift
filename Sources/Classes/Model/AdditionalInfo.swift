struct AdditionalInfo {
    let ftpRequestsLimit: FTPRequestsLimit?
    let ftpReactionsLimit: FTPReactionsLimits?
    let ftpUsersFeedLimit: FTPUsersFeedLimit?
}

struct FTPRequestsLimit {
    let available: Int
    let used: Int
}

struct FTPReactionsLimits: Equatable {
    let available: Int
    let used: Int
    let limit: Int
}

struct FTPUsersFeedLimit {
    let recomendationLimit: Int?
    let likesLimit: Int?
}

enum AdditionalInfoKeys: String {
    case available, used, limit
}
