import Quick
import Nimble
import Swinject
import SwinjectAutoregistration

@testable import SoulSwift

class ApplicationServiceTests: QuickSpec {

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
