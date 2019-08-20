import Foundation
import Moya

typealias SoulUsersProvider = MoyaProvider<SoulUsersApi>

// swiftlint:disable identifier_name
public enum SoulUsersApi {
    case recommendationsList
    case recommendationsRoulette
    case recommendationsFilter(method: Moya.Method)
    case recommendationsIncognitoFilter(method: Moya.Method)
    case recommendationsIncognitoList
    case recommendationsSetFilterName(filterName: String)
    case recommendationsSetFilterNameFilter(
        method: Moya.Method,
        filterName: String
    )
    case usersUserId(userId: String)
    case usersUserIdReactionsSent(
        method: Moya.Method,
        userId: String,
        reactionType: String
    )
    case usersUserIdFlag(
        method: Moya.Method,
        userId: String
    )
    case usersUserIdParametersPublicWritable(userId: String)
    case usersUserIdParametersPublicWritableParameterName(
        method: Moya.Method,
        userId: String,
        parameterName: String
    )
    case usersUserIdAlbums(userId: String)
    case usersUserIdAlbumsAlbumName(
        userId: String,
        albumName: String
    )
    case usersUserIdAlbumsAlbumNamePhotoId(
        userId: String,
        albumName: String,
        photoId: String
    )
}

extension SoulUsersApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .recommendationsList:
            return "/users/recommendations/list"
        case .recommendationsRoulette:
            return "/users/recommendations/roulette"
        case .recommendationsFilter:
            return "/users/recommendations/filter"
        case .recommendationsIncognitoFilter:
            return "/users/recommendations/incognito/filter"
        case .recommendationsIncognitoList:
            return "/users/recommendations/incognito/list"
        case .recommendationsSetFilterName(let filterName):
            return "/users/recommendations/set/\(filterName)"
        case .recommendationsSetFilterNameFilter(let filterName):
            return "/users/recommendations/set/\(filterName)/filter"
        case .usersUserId(let userId):
            return "/users/\(userId)"
        case .usersUserIdReactionsSent(_, let userId, let reactionType):
            return "/users/\(userId)/reactions/sent/\(reactionType)"
        case .usersUserIdFlag(let userId):
            return "/users/\(userId)/flag"
        case .usersUserIdParametersPublicWritable(let userId):
            return "/users/\(userId)/parameters/publicWritable"
        case .usersUserIdParametersPublicWritableParameterName(_, let userId, let parameterName):
            return "/users/\(userId)/parameters/publicWritable/\(parameterName)"
        case .usersUserIdAlbums(let userId):
            return "/users/\(userId)/albums"
        case .usersUserIdAlbumsAlbumName(let userId, let albumName):
            return "/users/\(userId)/albums/\(albumName)"
        case .usersUserIdAlbumsAlbumNamePhotoId(let userId, let albumName, let photoId):
            return "/users/\(userId)/albums/\(albumName)/\(photoId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .recommendationsFilter(let method):
            return method
        case .recommendationsIncognitoFilter(let method):
            return method
        case .recommendationsSetFilterNameFilter(let method, _):
            return method
        case .usersUserIdReactionsSent(let method, _, _):
            return method
        case .usersUserIdFlag(let method, _):
            return method
        case .usersUserIdParametersPublicWritableParameterName(let method, _, _):
            return method
        default:
            return .get
        }
    }

    public var task: Task {
        return .requestPlain
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return [:]
    }
}
