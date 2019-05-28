import Starscream

/// Hides WebSocket
protocol Socket: AnyObject {
    var isConnected: Bool { get }
    var onConnect: (() -> Void)? { get set }
    var onDisconnect: ((Error?) -> Void)? { get set }
    var onText: ((String) -> Void)? { get set }
    func write(string: String)
    func connect()
    func disconnect()
}

extension WebSocket: Socket {  }
