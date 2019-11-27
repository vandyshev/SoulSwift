import UIKit
import SoulSwift

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
//        setenv("CFNETWORK_DIAGNOSTICS", "3", 1)
        initializeSoulSwift()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - API Stuff

    private func initializeSoulSwift() {
        let configuration = SoulConfiguration(
            baseURL: "https://pure-api.soulplatform.com/",
            apiKey: "09561e912e8a1d5560ac1716f400aa93",
            appName: "Pure")
        SoulClient.shared.setup(withSoulConfiguration: configuration)
    }

    @IBAction func downloadFeatures(_ sender: Any) {
        SoulClient.shared.soulApplicationService?.features { result in
            switch result {
            case .success(let features):
                dump(features)
                SoulClient.shared.soulApplicationService?.additionalInfo(completion: { (result) in
                    dump(try? result.get())
                })
            case .failure(let error):
                switch error {
                case .soulError(let apiError):
                    print(apiError.userMessage)
                default:
                    break
                }
            }
        }
    }

    @IBAction func emailRequest(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        SoulClient.shared.soulAuthService?.emailCodeRequest(email: email, captchaToken: nil, completion: { result in
            switch result {
            case .success(let me):
                print(me)
            case .failure(let error):
                switch error {
                case .soulError(let apiError):
                    print(apiError.userMessage)
                default:
                    break
                }
            }
        })
    }

    @IBAction func emailVerify(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let code = codeTextField.text else { return }
        SoulClient.shared.soulAuthService?.emailCodeVerify(email: email, code: code, completion: { result in
            switch result {
            case .success(let me):
                print(me)
            case .failure(let error):
                switch error {
                case .soulError(let apiError):
                    print(apiError.userMessage)
                default:
                    break
                }
            }
        })
    }

    @IBAction func me(_ sender: Any) {
        SoulClient.shared.soulMeService?.me { result in
            switch result {
            case .success(let me):
                dump(me)
            case .failure(let error):
                dump(error)
            }
        }
    }
}
