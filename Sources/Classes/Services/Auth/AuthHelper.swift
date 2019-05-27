import UIKit
import CommonCrypto

struct AuthConfig {
    let endpoint: String
    let method: String
    let body: String
    let date: Date
}

protocol AuthHelper {
    func authString(withAuthConfig authConfig: AuthConfig) -> String?
    var userAgent: String { get }
}

private enum Constants {
    static let bundleNameKey = "CFBundleName"
    static let bundleVersionKey = "CFBundleVersion"
    static let bundleShortVersionStringKey = "CFBundleShortVersionString"
    static let simulatorModelIdentifierKey = "SIMULATOR_MODEL_IDENTIFIER"
}

public final class AuthHelperImpl: AuthHelper {

    private struct AuthData {
        let userID: String
        let sessionToken: String
        let date: Date
        let httpMethod: String
        let endpoint: String
        let body: String
    }

    private let storage: Storage
    private let appName: String

    init(storage: Storage, appName: String) {
        self.storage = storage
        self.appName = appName
    }

    var userAgent: String {
        return getUserAgent()
    }

    func authString(withAuthConfig authConfig: AuthConfig) -> String? {

        guard let userID = storage.userID, let sessionID = storage.sessionToken else {
            return nil
        }
        let delta: Double = storage.serverTimeDelta ?? 0
        let date = authConfig.date.addingTimeInterval(delta)

        let authData = AuthData(userID: userID,
                                sessionToken: sessionID,
                                date: date,
                                httpMethod: authConfig.method,
                                endpoint: authConfig.endpoint,
                                body: authConfig.body)

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

        let buildName = stringFromBundle(for: Constants.bundleNameKey) ?? "" // AppName
        let buildVersion = stringFromBundle(for: Constants.bundleVersionKey) ?? "" // 1234
        let appVersion = stringFromBundle(for: Constants.bundleShortVersionStringKey) ?? "" // 1.2.3-production
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

    private func stringFromBundle(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }

    private func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment[Constants.simulatorModelIdentifierKey] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine,
                                  count: Int(_SYS_NAMELEN)),
                                  encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
