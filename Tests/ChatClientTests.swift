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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isConnected = true
            self.onConnect?()
        }
    }

    func makeDisconnect() {
        isConnected = false
        onDisconnect?(nil)
    }

    func disconnect() {
        self.isConnected = false
    }
}

private class FakeSocketFactory: SocketFactoryProtocol {
    var socket: Socket?
    var hasSocket: Bool { return socket != nil }
}

class ChatClientTests: XCTestCase {

    private var client: ChatClient!
    private var errorService: ErrorService!
    private var factory: FakeSocketFactory!

    override func setUp() {
        factory = FakeSocketFactory()
        errorService = ErrorService()
        client = ChatClient(socketFactory: factory,
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
        let exp = expectation(description: "exp")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let status = self.client.connectionStatus
            XCTAssertEqual(status, ConnectionStatus.connected)
            let message = ChatMessage(messageId: "id",
                                      userId: "userID",
                                      timestamp: DateHelper.timestamp(from: Date()),
                                      text: "text",
                                      photoId: nil,
                                      albumName: nil,
                                      latitude: nil,
                                      longitude: nil)
            do {
                try self.client.sendMessage(message)
            } catch {
                fatalError()
            }
            XCTAssertEqual(socket.lastWritedText, message.asString)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testClientStartFinish() {
        let socket = SocketMock()
        factory.socket = socket
        do {
            try client.start()
        } catch {
            fatalError()
        }
        let exp = expectation(description: "exp")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.client.connectionStatus, ConnectionStatus.connected)
            self.client.finish()
            XCTAssertEqual(self.client.connectionStatus, ConnectionStatus.noSocket)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testClientReconnect() {
        let socket = SocketMock()
        factory.socket = socket
        let connectedExp = expectation(description: "connectedExp")
        connectedExp.expectedFulfillmentCount = 2
        connectedExp.assertForOverFulfill = true
        let disconnectedExp = expectation(description: "disconnectedExp")
        disconnectedExp.expectedFulfillmentCount = 2
        disconnectedExp.assertForOverFulfill = true

        var once = false
        client.subscribeToConnectionStatus(self) { status in
            switch status {
            case .connected:
                if !once {
                    once = true
                    socket.makeDisconnect()
                }
                connectedExp.fulfill()
            case .connecting:
                disconnectedExp.fulfill()
            case .noSocket:
                fatalError()
            }
        }
        do {
            try client.start()
        } catch {
            fatalError()
        }
        wait(for: [connectedExp, disconnectedExp], timeout: 4)
    }
}
