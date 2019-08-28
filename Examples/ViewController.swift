import UIKit
import SoulSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setenv("CFNETWORK_DIAGNOSTICS", "3", 1)
        // Do any additional setup after loading the view, typically from a nib.
//        setupFakeData()
        initializeSoulSwift()
        downloadFeatures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - API Stuff

    private func setupFakeData() {
        UserDefaults.standard.set("5bc843f0cf69ba78f995bc3b", forKey: "SOUL_SWIFT_USER_ID")
        UserDefaults.standard.set("693c11a7c74f9ff0bcb41c47d739acae", forKey: "SOUL_SWIFT_SESSION_TOKEN")
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

    private func downloadFeatures() {
        SoulSwiftClient.shared.soulApplicationService?.features { result in
            switch result {
            case .success(let features):
                print(features)
            case .failure(let error):
                switch error {
                case .apiError(let apiError):
                    print(apiError.userMessage)
                default:
                    break
                }
            }
        }

        SoulSwiftClient.shared.soulAuthService?.passwordRegister(
            login: "login14",
            password: "passwd14",
            merge: nil,
            mergePreference: nil,
            completion: { result in
                print("passwordRegister completion")
                switch result {
                case .success(let authResponse):
                    print(authResponse)
                case .failure(let error):
                    print(error)
                }

        })
    }
}
