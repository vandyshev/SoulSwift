// swiftlint:disable identifier_name
enum SoulUsersEndpoint {
    case recommendationsList
    case recommendationsRoulette
    case recommendationsFilter
    case recommendationsIncognitoFilter
    case recommendationsIncognitoList
    case setFilterName(filterName: String)
    case setFilterNameFilter(filterName: String)
    case usersUserId(userId: String)
    case usersUserIdReactionsSent(userId: String, reactionType: String)
    case usersUserIdFlag(userId: String)
    case usersUserIdParametersPublicWritable(userId: String)
    case usersUserIdParametersPublicWritableParameterName(userId: String, parameterName: String)
    case usersUserIdAlbums(userId: String)
    case usersUserIdAlbumsAlbumName(userId: String, albumName: String)
    case usersUserIdAlbumsAlbumNamePhotoId(userId: String, albumName: String, photoId: String)
}

extension SoulUsersEndpoint: SoulEndpoint {
    var path: String {
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
        case .setFilterName(let filterName):
            return "/users/set/\(filterName)"
        case .setFilterNameFilter(let filterName):
            return "/users/set/\(filterName)/filter"
        case .usersUserId(let userId):
            return "/users/\(userId)"
        case .usersUserIdReactionsSent(let userId, let reactionType):
            return "/users/\(userId)/reactions/sent/\(reactionType)"
        case .usersUserIdFlag(let userId):
            return "/users/\(userId)/flag"
        case .usersUserIdParametersPublicWritable(let userId):
            return "/users/\(userId)/parameters/publicWritable"
        case .usersUserIdParametersPublicWritableParameterName(let userId, let parameterName):
            return "/users/\(userId)/parameters/publicWritable/\(parameterName)"
        case .usersUserIdAlbums(let userId):
            return "/users/\(userId)/albums"
        case .usersUserIdAlbumsAlbumName(let userId, let albumName):
            return "/users/\(userId)/albums/\(albumName)"
        case .usersUserIdAlbumsAlbumNamePhotoId(let userId, let albumName, let photoId):
            return "/users/\(userId)/albums/\(albumName)/\(photoId)"
        }
    }
}
