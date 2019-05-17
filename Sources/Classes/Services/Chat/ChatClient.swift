import Foundation
import Starscream

public enum ConnectionStatus {
    case connected
    case connecting
}

extension ConnectionStatus {
    public var isConnected: Bool {
        guard case .connected = self else { return false }
        return true
    }
    public var isConnecting: Bool {
        guard case .connecting = self else { return false }
        return true
    }
}

protocol ChatClient: AnyObject {
    func connect()
    func sendMessage(_ payload: Encodable) -> Bool

    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void)
    func unsubscribe(_ observer: AnyObject)
}

protocol ChatClienStatusProvider: AnyObject {
    var connectionStatus: ConnectionStatus { get }
    func subscribeToConnectionStatus(_ observer: AnyObject, closure: @escaping (ConnectionStatus) -> Void)
    func unsubscribeFromConnectionStatus(_ observer: AnyObject)
}

private enum Constants {
    static let reconnectionTime: TimeInterval = 3
}

public final class ChatClientImpl: ChatClient, ChatClienStatusProvider {

    private var socket: WebSocket
    private let uriGenerator: ChatClientURIGenerator
    private let observable = Observable<Data>()
    private let statusObservable = Observable<ConnectionStatus>()

    public var connectionStatus: ConnectionStatus {
        return socket.isConnected ? .connected : .connecting
    }

    init(uriGenerator: ChatClientURIGenerator) {
        self.uriGenerator = uriGenerator

        guard let uri = uriGenerator.wsConnectionURI else {
            fatalError("impossible web socket url")
        }

        socket = WebSocket(url: uri)

        socket.onConnect = { [weak self] in
            self?.broadcastStatus()
            print("websocket is connected")
        }

        socket.onDisconnect = { [weak self] (error: Error?) in
            self?.reconnect()
            print("websocket is disconnected: \(error)")
        }

        socket.onText = { [weak self] (text: String) in
            self?.onText(text)
            print("got some text: \(text)")
        }

        socket.onHttpResponseHeaders = {
            print("HttpResponseHeaders \($0)")
        }
        connect()
    }

    func connect() {
        broadcastStatus()
        socket.connect()
    }

    private func broadcastStatus() {
        statusObservable.broadcast(connectionStatus)
    }

    private func reconnect() {
        broadcastStatus()
        if connectionStatus == .connected { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.reconnectionTime) { [weak self] in
            if self?.connectionStatus == .connected { return }
            self?.connect()
        }
    }

    @objc private func updateConnectionStatus() {
        if !socket.isConnected {
            connect()
        }
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
