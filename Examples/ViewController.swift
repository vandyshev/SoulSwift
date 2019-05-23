import UIKit
import SoulSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeSoulSwift()
        downloadFeatures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - API Stuff

    func initializeSoulSwift() {
        setupFakeData()
        let configuration = SoulConfiguration(
            baseURL: "https://testing-api.soulplatform.com",
            apiKey: "b9ef962ad2323fea17085bbe3fd7a35b",
            appName: "PureFTP",
            chatURL: "wss://chats-testing.soulplatform.com/",
            chatApiKey: "1b7e5656-b0f3-4190-a368-c8ac01ac0373")
        SoulSwiftClient.shared.setup(withSoulConfiguration: configuration)
    }

    private func setupFakeData() {
        UserDefaults.standard.set("userID", forKey: "SL/USER_ID")
        UserDefaults.standard.set("sessionID", forKey: "SL/SESSION_TOKEN")
    }

    func downloadFeatures() {
        SoulSwiftClient.shared.soulApplicationService?.features(anonymousId: "CF6421EB-B450-41A0-A572-89FCE3FB0C2F", completion: {
            print("completion")
        })
    }

}
