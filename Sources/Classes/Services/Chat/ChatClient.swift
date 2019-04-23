import Foundation
import Starscream

protocol ChatClient {
    func connect()
    func sendMessage(_ payload: Encodable) -> Bool // TODO: use decodable instead
}

// not implemented yet
public final class ChatClientImpl: ChatClient {

    private var socket: WebSocket
    private let uriGenerator: ChatClientURIGenerator

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
        socket.onText = { (text: String) in
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
}
