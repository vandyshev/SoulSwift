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

class ChatApiTests: XCTestCase {

    var provider: MoyaProvider<ChatApi>!
    var fakeStorage: Storage!
    var deviceHandler: DeviceHandler!
    var fakeDeviceIDStorage: DeviceIdStorage!
    var chatURIGeneratorConfig: ChatURIGeneratorConfig!
    var chatApiURLGenerator: ChatApiURLGenerator!
    var authHelper: AuthHelper!

    override func setUp() {
        self.provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        self.fakeStorage = FakeStorage(userID: Constants.fakeUserID,
                                       sessionToken: Constants.fakeSessionID,
                                       serverTimeDelta: 0)
        self.fakeDeviceIDStorage = FakeDeviceIdStorage(deviceID: Constants.fakeDeviceID)
        self.deviceHandler = DeviceHandlerImpl(storage: fakeDeviceIDStorage)
        self.chatURIGeneratorConfig = ChatURIGeneratorConfig(baseUrlString: Constants.fakeURL,
                                                             apiKey: Constants.fakeApiKey)
        self.authHelper = AuthHelperImpl(storage: fakeStorage,
                                         appName: Constants.fakeAppName)
        self.chatApiURLGenerator = ChatClientURIGeneratorImpl(config: chatURIGeneratorConfig,
                                                              authHelper: authHelper,
                                                              deviceHandler: deviceHandler)
    }

    override func tearDown() {
        self.provider = nil
    }

    func testURL() {
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
                              urlGenerator: chatApiURLGenerator)
        let endPoint = provider.endpoint(chatApi)

        guard let request = try? endPoint.urlRequest() else {
            fatalError()
        }
        let expectedURL =
            "https://\(Constants.fakeURL)\(Constants.fakeApiKey)/v1/chat/history/channel.name" +
            "?before=\(Int(dateInSeconds))&limit=\(limit)&offset=\(defaultOffset)"
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
    }
}
