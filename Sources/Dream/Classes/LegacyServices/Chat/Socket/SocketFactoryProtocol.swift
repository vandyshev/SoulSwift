import Starscream

/// Generates socket if possible
protocol SocketFactoryProtocol: AnyObject {
    var socket: Socket? { get }
    var hasSocket: Bool { get }
}

class SocketFactory: SocketFactoryProtocol {

    private let uriFactory: ChatClientURIFactoryProtocol

    var hasSocket: Bool {
        return uriFactory.wsConnectionURI != nil
    }

    init(uriFactory: ChatClientURIFactoryProtocol) {
        self.uriFactory = uriFactory
    }

    var socket: Socket? {
        guard let uri = uriFactory.wsConnectionURI else {
            return nil
        }
        return WebSocket(url: uri)
    }
}
