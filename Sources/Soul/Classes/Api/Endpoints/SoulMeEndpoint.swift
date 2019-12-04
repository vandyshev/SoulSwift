enum SoulMeEndpoint {
    case me
    case incognito
    case parameters(scope: String, path: String)
    case productsSubscriptionsAvailable
    case albums
    case albumsAlbumName(albumName: String)
    case albumsAlbumNamePhotoId(albumName: String, photoId: String)
}

extension SoulMeEndpoint: SoulEndpoint {
    var path: String {
        switch self {
        case .me:
            return "/me"
        case .incognito:
            return "/me/incognito"
        case .parameters(let scope, let path):
            return "/me/parameters/\(scope)/\(path)"
        case .productsSubscriptionsAvailable:
            return "/me/products/subscriptions/available"
        case .albums:
            return "/me/albums"
        case .albumsAlbumName(let albumName):
            return "/me/albums/\(albumName)"
        case .albumsAlbumNamePhotoId(let albumName, let photoId):
            return "/me/albums/\(albumName)/\(photoId)"
        }
    }
}
