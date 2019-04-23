import Foundation
import Starscream

protocol ChatClient {
    func connect()
    func sendMessage(_ payload: Encodable) -> Bool
    func subscribe(_ observer: AnyObject, closure: @escaping (Data) -> Void)
    func unsubscribe(_ observer: AnyObject)
}

// not implemented yet
public final class ChatClientImpl: ChatClient {

    private var socket: WebSocket
    private let uriGenerator: ChatClientURIGenerator
    private let observable = Observable<Data>()

    init(uriGenerator: ChatClientURIGenerator) {
        self.uriGenerator = uriGenerator

        guard let uri = uriGenerator.uri else {
            fatalError("impossible web socket url")
        }

        socket = WebSocket(url: uri)

        socket.onConnect = {
            print("websocket is connected")
        }
        //websocketDidDisconnect
        socket.onDisconnect = { [weak self] (error: Error?) in
            print("websocket is disconnected: \(error)")
            self?.connect()
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
}
