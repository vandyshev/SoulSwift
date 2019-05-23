import Foundation

public enum ConnectionStatus {
    case connected
    case connecting
    case noSocket
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

    func start() -> Bool
    func finish()

    func sendMessage(_ payload: Encodable) -> Bool

    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void)
    func unsubscribe(_ observer: AnyObject)

    var connectionStatus: ConnectionStatus { get }
    func subscribeToConnectionStatus(_ observer: AnyObject, closure: @escaping (ConnectionStatus) -> Void)
    func unsubscribeFromConnectionStatus(_ observer: AnyObject)
}

private enum Constants {
    static let reconnectionTime: TimeInterval = 3
}

public final class ChatClientImpl: ChatClient {

    private var socket: Socket?
    private let socketFactory: SocketFactory
    private let observable = Observable<Data>()
    private let statusObservable = Observable<ConnectionStatus>()

    public var connectionStatus: ConnectionStatus {
        guard let socket = socket else {
            return .noSocket
        }
        return socket.isConnected ? .connected : .connecting
    }

    init(socketFactory: SocketFactory) {
        self.socketFactory = socketFactory
    }

    func start() -> Bool {
        guard let socket = socketFactory.socket else {
            return false
        }

        self.socket = socket

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

        connect()
        return true
    }

    func finish() {
        self.socket?.disconnect()
        self.socket?.onConnect = nil
        self.socket?.onDisconnect = nil
        self.socket?.onText = nil
        self.socket = nil
        broadcastStatus()
    }

    private func connect() {
        broadcastStatus()
        socket?.connect()
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
        if let socket = socket, !socket.isConnected {
            connect()
        }
    }

    func sendMessage(_ payload: Encodable) -> Bool {
        guard let socket = socket else { return false }
        if socket.isConnected {
            guard let messageString = payload.asString else {
                return false
            }
            socket.write(string: messageString)
        }
        return socket.isConnected
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
