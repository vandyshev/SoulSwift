import XCTest
@testable import SoulSwift

private class SocketMock: Socket {

    var lastWritedText: String?

    var isConnected: Bool = false

    var onConnect: (() -> Void)?

    var onDisconnect: ((Error?) -> Void)?

    var onText: ((String) -> Void)?

    func write(string: String) {
        lastWritedText = string
    }

    func connect() {
        self.isConnected = true
    }

    func disconnect() {
        self.isConnected = false
    }
}

private class FakeSocketFactory: SocketFactory {
    var socket: Socket?
}

class ChatClientTests: XCTestCase {

    private var client: ChatClientImpl!
    private var errorService: ErrorServiceImpl!
    private var factory: FakeSocketFactory!

    override func setUp() {
        factory = FakeSocketFactory()
        errorService = ErrorServiceImpl()
        client = ChatClientImpl(socketFactory: factory,
                                errorService: errorService)
    }

    override func tearDown() {
        client = nil
        errorService = nil
        factory = nil
    }

    func testClientStartFailed() {
        factory.socket = nil
        do {
            try client.start()
            fatalError()
        } catch {
            // expected
        }
        do {
            try client.sendMessage("hello")
            fatalError()
        } catch {
            // expected
        }
        let status = client.connectionStatus
        XCTAssertEqual(status, ConnectionStatus.noSocket)
    }

    func testClientStartSuccess() {
        let socket = SocketMock()
        factory.socket = socket
        do {
            try client.start()
        } catch {
            fatalError()
        }
        let status = client.connectionStatus
        XCTAssertEqual(status, ConnectionStatus.connected)
        let message = ChatMessage(messageId: "id",
                                  userId: "userID",
                                  timestamp: DateHelper.currentUnixTimestamp,
                                  text: "text",
                                  photoId: nil,
                                  albumName: nil,
                                  latitude: nil,
                                  longitude: nil)
        do {
            try client.sendMessage(message)
        } catch {
            fatalError()
        }
        XCTAssertEqual(socket.lastWritedText, message.asString)
    }

    func testClientStartFinish() {
        let socket = SocketMock()
        factory.socket = socket
        do {
            try client.start()
        } catch {
            fatalError()
        }
        XCTAssertEqual(client.connectionStatus, ConnectionStatus.connected)
        client.finish()
        XCTAssertEqual(client.connectionStatus, ConnectionStatus.noSocket)
    }
}
