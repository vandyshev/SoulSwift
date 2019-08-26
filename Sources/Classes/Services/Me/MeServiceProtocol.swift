// swiftlint:disable line_length
public protocol MeServiceProtocol {
    // GET: /me
    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
     // PATCH: /me
    func setParameters(parameters: MeParameters, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void)
    // DELETE: /me
    func deleteMe(completion: @escaping (Result<Void, SoulSwiftError>) -> Void)

    // GET: /me/albums
    func loadAlbums(offset: Int?, limit: Int?, completion: @escaping (Result<[Album], SoulSwiftError>) -> Void)
    // POST: /me/albums
    func addAlbum(parameters: AlbumParameters, completion: @escaping (Result<Album, SoulSwiftError>) -> Void)
    // GET: /me/albums/{albumName}
    func loadAlbum(albumName: String, offset: Int?, limit: Int?, completion: @escaping (Result<Album, SoulSwiftError>) -> Void)
    // PATCH: /me/albums/{albumName}
    func editAlbum(albumName: String, parameters: AlbumParameters, offset: Int?, limit: Int?, completion: @escaping (Result<Album, SoulSwiftError>) -> Void)
    // DELETE: /me/albums/{albumName}
    func deleteAlbum(albumName: String, offset: Int?, limit: Int?, completion: @escaping (Result<Void, SoulSwiftError>) -> Void)

    // POST: /me/albums/{albumName} multipart
    func addPhoto(albumName: String, photo: Data, offset: Int?, limit: Int?, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void)
    // GET: /me/albums/{albumName}/{photoId}
    func photo(albumName: String, photoId: String, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void)
    // PATCH: /me/albums/{albumName}/{photoId}
    func editPhoto(albumName: String, photoId: String, parameters: PhotoParameters, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void)
    // DELETE: /me/albums/{albumName}/{photoId}
    func deletePhoto(albumName: String, photoId: String, completion: @escaping (Result<Void, SoulSwiftError>) -> Void)
}

final class MeService: MeServiceProtocol {

    let soulProvider: SoulProviderProtocol

    init(soulProvider: SoulProviderProtocol) {
        self.soulProvider = soulProvider
    }

    func me(completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.me,
            bodyParameters: nil,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setNotificationToken(apnsToken: String, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            bodyParameters: ["notificationTokens": ["APNS": apnsToken]],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func setParameters(parameters: MeParameters, completion: @escaping (Result<MyUser, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.me,
            body: parameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.me })
        }
    }

    func deleteMe(completion: @escaping (Result<Void, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .DELETE,
            soulEndpoint: SoulMeEndpoint.me,
            bodyParameters: nil,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    func loadAlbums(offset: Int?, limit: Int?, completion: @escaping (Result<[Album], SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.albums,
            queryParameters: ["offset": offset, "limit": limit],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.albums })
        }
    }

    func addAlbum(parameters: AlbumParameters, completion: @escaping (Result<Album, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulMeEndpoint.albums,
            body: parameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.album })
        }
    }

    func loadAlbum(albumName: String, offset: Int?, limit: Int?, completion: @escaping (Result<Album, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.albumsAlbumName(albumName: albumName),
            queryParameters: ["offset": offset, "limit": limit],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.album })
        }
    }

    func editAlbum(albumName: String, parameters: AlbumParameters, offset: Int?, limit: Int?, completion: @escaping (Result<Album, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.albumsAlbumName(albumName: albumName),
            queryParameters: ["offset": offset, "limit": limit],
            body: parameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.album })
        }
    }

    func deleteAlbum(albumName: String, offset: Int?, limit: Int?, completion: @escaping (Result<Void, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .DELETE,
            soulEndpoint: SoulMeEndpoint.albumsAlbumName(albumName: albumName),
            queryParameters: ["offset": offset, "limit": limit],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }

    // TODO: multipart/form-data
    func addPhoto(albumName: String, photo: Data, offset: Int?, limit: Int?, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .POST,
            soulEndpoint: SoulMeEndpoint.albumsAlbumName(albumName: albumName),
            queryParameters: ["offset": offset, "limit": limit],
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.photo })
        }
    }

    func photo(albumName: String, photoId: String, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            soulEndpoint: SoulMeEndpoint.albumsAlbumNamePhotoId(albumName: albumName, photoId: photoId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.photo })
        }
    }

    func editPhoto(albumName: String, photoId: String, parameters: PhotoParameters, completion: @escaping (Result<Photo, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .PATCH,
            soulEndpoint: SoulMeEndpoint.albumsAlbumNamePhotoId(albumName: albumName, photoId: photoId),
            body: parameters,
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { $0.photo })
        }
    }

    func deletePhoto(albumName: String, photoId: String, completion: @escaping (Result<Void, SoulSwiftError>) -> Void) {
        let request = SoulRequest(
            httpMethod: .DELETE,
            soulEndpoint: SoulMeEndpoint.albumsAlbumNamePhotoId(albumName: albumName, photoId: photoId),
            needAuthorization: true
        )
        soulProvider.request(request) { (result: Result<SoulResponse, SoulSwiftError>) in
            completion(result.map { _ in })
        }
    }
}
