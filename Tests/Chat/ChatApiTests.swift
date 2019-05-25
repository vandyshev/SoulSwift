import XCTest
import Foundation
import Moya
@testable import SoulSwift

private enum Constants {
    static let fakeUserID = "userID"
    static let fakeSessionID = "sessionID"
    static let fakeAppName = "appName"
    static let fakeDeviceID = "fakeDeviceID"
    static let fakeURL = "www.myURL.com/"
    static let fakeApiKey = "fakeApiKey"
}

class URLTests: XCTestCase {

    var provider: MoyaProvider<ChatApi>!
    var fakeStorage: Storage!
    var deviceHandler: DeviceHandler!
    var fakeDeviceIDStorage: DeviceIdStorage!
    var chatURIFactoryConfig: ChatURIFactoryConfig!
    var chatApiURLFactory: ChatApiURLFactory!
    var chatClientURIFactory: ChatClientURIFactory!
    var authHelper: AuthHelper!

    override func setUp() {
        self.provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        self.fakeStorage = FakeStorage(userID: Constants.fakeUserID,
                                       sessionToken: Constants.fakeSessionID,
                                       serverTimeDelta: 1)
        self.fakeDeviceIDStorage = FakeDeviceIdStorage(deviceID: Constants.fakeDeviceID)
        self.deviceHandler = DeviceHandlerImpl(storage: fakeDeviceIDStorage)
        self.chatURIFactoryConfig = ChatURIFactoryConfig(baseUrlString: Constants.fakeURL,
                                                         apiKey: Constants.fakeApiKey)
        self.authHelper = AuthHelperImpl(storage: fakeStorage,
                                         appName: Constants.fakeAppName)
        let chatClientURIFactoryImpl = ChatClientURIFactoryImpl(config: chatURIFactoryConfig,
                                                                authHelper: authHelper,
                                                                deviceHandler: deviceHandler)
        self.chatApiURLFactory = chatClientURIFactoryImpl
        self.chatClientURIFactory = chatClientURIFactoryImpl
    }

    override func tearDown() {
        self.provider = nil
    }

    func testChatApiURL() {
        let limit = 100
        let defaultOffset = 0
        let dateInSeconds: Double = 1558600194
        let olderThan = Date(timeIntervalSince1970: dateInSeconds)
        let channel = "channel.name"

        let chatHistoryConfig = ChatHistoryConfig(limit: limit,
                                                  offset: defaultOffset,
                                                  beforeTimestamp: DateHelper.timestamp(from: olderThan),
                                                  afterTimestamp: nil,
                                                  beforeIdentifier: nil,
                                                  afterIdentifer: nil,
                                                  beforeMessageIdentifier: nil,
                                                  afterMessageIdentifer: nil)

        let chatApi = ChatApi(chatHistoryConfig: chatHistoryConfig,
                              channel: channel,
                              authHelper: authHelper,
                              urlFactory: chatApiURLFactory)
        let endPoint = provider.endpoint(chatApi)

        guard let request = try? endPoint.urlRequest() else {
            fatalError()
        }
        let expectedURL =
            "https://\(Constants.fakeURL)\(Constants.fakeApiKey)/v1/chat/history/channel.name" +
            "?before=\(Int(dateInSeconds))&limit=\(limit)&offset=\(defaultOffset)"
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
    }

    func testAuthString() {
        let wsAuthEndpoint = "/me"
        let wsAuthMethod = "GET"
        let wsAuthBody = ""
        let date = Date(timeIntervalSince1970: 1558780958)
        let authConfig = AuthConfig(endpoint: wsAuthEndpoint,
                                    method: wsAuthMethod,
                                    body: wsAuthBody,
                                    date: date)
        guard let authString = authHelper.authString(withAuthConfig: authConfig) else {
            fatalError()
        }
        let expected = "hmac \(Constants.fakeUserID):1558780959:571e880688d17e39376599c0266d0f77172ac7ccd67ea21c176812465058a4b0"
        XCTAssertEqual(expected, authString)
    }

    func testWsURL() {
        guard let url = chatClientURIFactory.wsConnectionURI else {
            fatalError()
        }
        let firstPart = "wss://\(Constants.fakeURL)\(Constants.fakeApiKey)/v1/ws?auth=hmac%20\(Constants.fakeUserID)"
        let middlePart = "&user-agent=appName/1.0"
        let lastPart = "(iOS)&device-id=\(Constants.fakeDeviceID)"
        XCTAssertTrue(url.absoluteString.hasPrefix(firstPart))
        XCTAssertTrue(url.absoluteString.contains(middlePart))
        XCTAssertTrue(url.absoluteString.hasSuffix(lastPart))
    }
}
