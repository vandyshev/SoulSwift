import Foundation
import Moya

typealias SoulMeProvider = MoyaProvider<SoulMeApi>

public enum SoulMeApi {
    case me(method: Moya.Method)
    case incognito(method: Moya.Method)
    case parameters(
        method: Moya.Method,
        scope: String,
        path: String
    )
    case productsSubscriptionsAvailable
    case albums(method: Moya.Method)
    case albumsAlbumName(
        method: Moya.Method,
        albumName: String)
    case albumsAlbumNamePhotoId(
        method: Moya.Method,
        albumName: String,
        photoId: String
    )
}

extension SoulMeApi: TargetType, AuthorizedTargetType, APIVersionTargetType {

    var needsAuth: Bool {
        return true
    }

    var needsAPIVersion: Bool {
        return true
    }

    public var baseURL: URL { return URL(string: SoulSwiftClient.shared.soulConfiguration!.baseURL)! }

    public var path: String {
        switch self {
        case .me:
            return "/me"
        case .incognito:
            return "/me/incognito"
        case .parameters(_, let scope, let path):
            return "/me/parameters/\(scope)/\(path)"
        case .productsSubscriptionsAvailable:
            return "/me/products/subscriptions/available"
        case .albums:
            return "/me/albums"
        case .albumsAlbumName(_, let albumName):
            return "/me/albums/\(albumName)"
        case .albumsAlbumNamePhotoId(_, let albumName, let photoId):
            return "/me/albums/\(albumName)/\(photoId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .me(let method):
            return method
        case .incognito(let method):
            return method
        case .parameters(let method, _, _):
            return method
        case .productsSubscriptionsAvailable:
            return .get
        case .albums(let method):
            return method
        case .albumsAlbumName(let method, _):
            return method
        case .albumsAlbumNamePhotoId(let method, _, _):
            return method
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
