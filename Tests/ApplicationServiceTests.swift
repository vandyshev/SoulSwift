import Quick
import Nimble
import Moya
import Swinject
import SwinjectAutoregistration

@testable import SoulSwift

class ApplicationServiceTests: QuickSpec {

    private func setupFakeData() {
        UserDefaults.standard.set("5bc843f0cf69ba78f995bc3b", forKey: "SOUL_SWIFT_USER_ID")
        UserDefaults.standard.set("693c11a7c74f9ff0bcb41c47d739acae", forKey: "SOUL_SWIFT_SESSION_TOKEN")
    }

    private func cleanUpFakeData() {
        UserDefaults.standard.removeObject(forKey: "SOUL_SWIFT_USER_ID")
        UserDefaults.standard.removeObject(forKey: "SOUL_SWIFT_SESSION_TOKEN")
    }

    private func initializeSoulSwift() {
        let configuration = SoulConfiguration(
            baseURL: "https://testing-api.soulplatform.com",
            apiKey: "0f8380018608ab28061fe7c3a499065b",
            appName: "Pure",
            chatURL: "wss://chats-testing.soulplatform.com/",
            chatApiKey: "1b7e5656-b0f3-4190-a368-c8ac01ac0373")
        SoulSwiftClient.shared.setup(withSoulConfiguration: configuration)
    }

    override func spec() {
        describe("application service") {
            beforeEach {
                self.cleanUpFakeData()
                self.initializeSoulSwift()
            }

            context("when feature request") {
                it("call completion") {
                    var isDone = false

                    waitUntil { done in
                        SoulSwiftClient.shared.soulApplicationService?.features { _ in
                            isDone = true
                            done()
                        }
                    }

                    expect(isDone).to(beTrue())
                }
            }
        }
    }
}
