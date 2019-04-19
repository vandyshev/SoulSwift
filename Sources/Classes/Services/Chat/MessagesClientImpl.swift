import UIKit
import Starscream

// not implemented yet
public final class ChatClientImpl: ChatClient {

    private let socket: WebSocket
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
        socket.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error)")
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

    public func connect() {
        socket.connect()
    }
}
