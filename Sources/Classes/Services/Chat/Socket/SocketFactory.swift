import Starscream

/// Generates socket if possible
protocol SocketFactory: AnyObject {
    var socket: Socket? { get }
}

class SocketFactoryImpl: SocketFactory {

    private let uriGenerator: ChatClientURIGenerator

    init(uriGenerator: ChatClientURIGenerator) {
        self.uriGenerator = uriGenerator
    }

    var socket: Socket? {
        guard let uri = uriGenerator.wsConnectionURI else {
            return nil
        }
        return WebSocket(url: uri)
    }
}
