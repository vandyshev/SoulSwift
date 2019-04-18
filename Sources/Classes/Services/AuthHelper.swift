import UIKit
import CommonCrypto

protocol AuthHelper {
    func authString(withEndpoint endpoint: String, method: String, body: String) -> String?
    var userAgent: String { get }
}

public struct AuthData { // make private
    let userID: String
    let sessionToken: String
    let date: Date
    let httpMethod: String
    let endpoint: String
    let body: String
}

public final class AuthHelperImpl: AuthHelper {

    private let storage: Storage
    private let appName: String
    
    init(storage: Storage, appName: String) {
        self.storage = storage
        self.appName = appName
    }
    
    var userAgent: String {
        return getUserAgent()
    }
    
    func authString(withEndpoint endpoint: String, method: String, body: String) -> String? {
        
        guard let userID = storage.userID, let sessionID = storage.sessionToken else {
            return nil
        }
        let delta: Double = storage.serverTimeDelta ?? 0
        let date = Date().addingTimeInterval(delta)
        
        let authData = AuthData(userID: userID,
                                sessionToken: sessionID,
                                date: date,
                                httpMethod: method,
                                endpoint: endpoint,
                                body: body)
        
        return authString(authData: authData)
    }
    
    private func authString(authData: AuthData) -> String {
        
        let unixtime = "\(Int(round(authData.date.timeIntervalSince1970)))"
        let rawDigest = "\(authData.httpMethod)+\(authData.endpoint)+\(authData.body)+\(unixtime)"
        let digest = hmacSHA256(from: rawDigest, key: authData.sessionToken)
        let hmac = "hmac \(authData.userID):\(unixtime):\(digest)"
        return hmac
    }
    
    
    private func hmacSHA256(from string: String, key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, string, string.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }

    private func getUserAgent() -> String {
        let bundle = Bundle.main
        let buildName = bundle.object(forInfoDictionaryKey: "CFBundleName") as! String // AppName
        let buildVersion = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as! String // 1234
        let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String // 1.2.3-production
        let model = modelIdentifier() // iPhone 5S
        let iosVersion = UIDevice.current.systemVersion // 8.3
        
        let correctedAppVersion: String = {
            // appVersion may have suffix, for example 1.2.3-production. We don't need it here
            if let range = appVersion.range(of: "-") {
                return appVersion.substring(with: range)
            }
            return appVersion
        }()
        
        let language = NSLocale.current.identifier
        
        let userAgent = "\(appName)/\(appVersion) (iOS \(iosVersion); \(model); \(language); b\(buildVersion)) SoulSDK/1.0.1 (iOS)"
        return userAgent
    }
    
    private func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine,
                                  count: Int(_SYS_NAMELEN)),
                                  encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
}
