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

    func start() throws
    func finish()

    func sendMessage(_ payload: Encodable) throws

    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void)
    func unsubscribe(_ observer: AnyObject)

    var connectionStatus: ConnectionStatus { get }
    func subscribeToConnectionStatus(_ observer: AnyObject, closure: @escaping (ConnectionStatus) -> Void)
    func unsubscribeFromConnectionStatus(_ observer: AnyObject)
}

private enum Constants {
    static let reconnectionTime: TimeInterval = 3
}

private enum ChatClientError: Error {
    case cannotStartSocket
    case cannotEncodeMessage
    case noSocket
    case socketIsDisconnected
}

extension ChatClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotStartSocket:
            return "Can't start socket"
        case .cannotEncodeMessage:
            return "Cannot encode message"
        case .noSocket:
            return "Socket haven't been started yet"
        case .socketIsDisconnected:
            return "Socket is disconnected"
        }
    }
}

public final class ChatClientImpl: ChatClient {

    private var socket: Socket?
    private let socketFactory: SocketFactory
    private let errorService: InternalErrorService
    private let observable = Observable<Data>()
    private let statusObservable = Observable<ConnectionStatus>()

    public var connectionStatus: ConnectionStatus {
        guard let socket = socket else {
            return .noSocket
        }
        return socket.isConnected ? .connected : .connecting
    }
    private var lastBroadcastedStatus: ConnectionStatus?
    private var isStarted = false

    init(socketFactory: SocketFactory, errorService: InternalErrorService) {
        self.socketFactory = socketFactory
        self.errorService = errorService
    }

    func start() throws {
        guard socketFactory.hasSocket else {
            throw getApiError(.cannotStartSocket)
        }
        isStarted = true
        connect()
    }

    private func connect() {
        if isStarted, let socket = socketFactory.socket {
            subscribeOnEvents(socket: socket)
            self.socket = socket
        }
        broadcastStatus()
        socket?.connect()
    }

    func finish() {
        socket?.disconnect()
        socket = nil
        isStarted = false
        broadcastStatus()
    }

    private func subscribeOnEvents(socket: Socket) {
        socket.onConnect = { [weak self] in
            self?.broadcastStatus()
            print("websocket is connected")
        }

        socket.onDisconnect = { [weak self] (error: Error?) in
            if let error = error {
                let apiError: ApiError = .chatSocketError(error)
                self?.errorService.handleError(apiError)
            }
            self?.reconnect()
            print("websocket is disconnected: \(error)")
        }

        socket.onText = { [weak self] (text: String) in
            self?.onText(text)
            print("got some text: \(text)")
        }
    }

    private func broadcastStatus() {
        if lastBroadcastedStatus != connectionStatus {
            lastBroadcastedStatus = connectionStatus
            statusObservable.broadcast(connectionStatus)
        }
    }

    private func reconnect() {
        broadcastStatus()
        if connectionStatus == .connected { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.reconnectionTime) { [weak self] in
            if self?.connectionStatus == .connected { return }
            self?.connect()
        }
    }

    func sendMessage(_ payload: Encodable) throws {
        guard let socket = socket else {
            throw getApiError(.noSocket)
        }
        guard socket.isConnected else {
            throw getApiError(.socketIsDisconnected)
        }
        guard let messageString = payload.asString else {
            throw getApiError(.cannotEncodeMessage)
        }
        socket.write(string: messageString)
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

    private func getApiError(_ error: ChatClientError) -> ApiError {
        let apiError: ApiError = .chatSocketError(error)
        errorService.handleError(apiError)
        return apiError
    }
}
