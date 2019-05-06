import Foundation
import Starscream

public enum ConnectionStatus {
    case connected
    case connecting
    case disconected
}

protocol ChatClient {
    var connectionStatus: ConnectionStatus { get }

    func connect()
    func sendMessage(_ payload: Encodable) -> Bool

    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void)
    func unsubscribe(_ observer: AnyObject)

    func subscribeToConnectionStatus(_ observer: AnyObject, closure: @escaping (ConnectionStatus) -> Void)
    func unsubscribeFromConnectionStatus(_ observer: AnyObject)
}

// not implemented yet
public final class ChatClientImpl: ChatClient {

    private var socket: WebSocket
    private let uriGenerator: ChatClientURIGenerator
    private let observable = Observable<Data>()
    private let statusObservable = Observable<ConnectionStatus>()

    public private(set) var connectionStatus: ConnectionStatus = .disconected {
        didSet {
            statusObservable.broadcast(connectionStatus)
        }
    }

    init(uriGenerator: ChatClientURIGenerator) {
        self.uriGenerator = uriGenerator

        guard let uri = uriGenerator.wsConnectionURI else {
            fatalError("impossible web socket url")
        }

        socket = WebSocket(url: uri)

        socket.onConnect = { [weak self] in
            self?.connectionStatus = .connected
            print("websocket is connected")
        }
        //websocketDidDisconnect
        socket.onDisconnect = { [weak self] (error: Error?) in
            self?.connectionStatus = .disconected
            print("websocket is disconnected: \(error)")
        }
        //websocketDidReceiveMessage
        socket.onText = { [weak self] (text: String) in
            self?.onText(text)
            print("got some text: \(text)")
        }
        //websocketDidReceiveData
        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }
        connect()
    }

    func connect() {
        connectionStatus = .connecting
        socket.connect()
    }

    func sendMessage(_ payload: Encodable) -> Bool {
        if socket.isConnected == true {
            guard let messageString = payload.asString else {
                return false
            }
            socket.write(string: messageString)
        }
        return socket.isConnected == true
    }

    private func onText(_ string: String) {
        guard let data = string.data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        observable.broadcast(data)
    }

    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void) {
        observable.subscribe(observer, closure: closure)
    }

    func unsubscribe(_ observer: AnyObject) {
        observable.unsubscribe(observer)
    }

    func subscribeToConnectionStatus(_ observer: AnyObject, closure: @escaping (ConnectionStatus) -> Void) {
        statusObservable.subscribe(observer, closure: closure)
    }

    func unsubscribeFromConnectionStatus(_ observer: AnyObject) {
        statusObservable.unsubscribe(observer)
    }
}
