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
        let startResult = client.start()
        XCTAssertFalse(startResult)
        let sendMessageResult = client.sendMessage("hello")
        XCTAssertFalse(sendMessageResult)
        let status = client.connectionStatus
        XCTAssertEqual(status, ConnectionStatus.noSocket)
    }

    func testClientStartSuccess() {
        let socket = SocketMock()
        factory.socket = socket
        let startResult = client.start()
        XCTAssertTrue(startResult)
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
        let sendMessageResult = client.sendMessage(message)
        XCTAssertTrue(sendMessageResult)
        XCTAssertEqual(socket.lastWritedText, message.asString)
    }

    func testClientStartFinish() {
        let socket = SocketMock()
        factory.socket = socket
        let startResult = client.start()
        XCTAssertTrue(startResult)
        XCTAssertEqual(client.connectionStatus, ConnectionStatus.connected)
        client.finish()
        XCTAssertEqual(client.connectionStatus, ConnectionStatus.noSocket)
    }
}
