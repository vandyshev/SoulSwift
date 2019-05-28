import Starscream

/// Generates socket if possible
protocol SocketFactory: AnyObject {
    var socket: Socket? { get }
}

class SocketFactoryImpl: SocketFactory {

    private let uriFactory: ChatClientURIFactory

    init(uriFactory: ChatClientURIFactory) {
        self.uriFactory = uriFactory
    }

    var socket: Socket? {
        guard let uri = uriFactory.wsConnectionURI else {
            return nil
        }
        return WebSocket(url: uri)
    }
}
