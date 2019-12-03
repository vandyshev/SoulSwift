private enum Constants {
    static let bundleNameKey = "CFBundleName"
    static let bundleVersionKey = "CFBundleVersion"
    static let bundleShortVersionStringKey = "CFBundleShortVersionString"
    static let simulatorModelIdentifierKey = "SIMULATOR_MODEL_IDENTIFIER"
    static let soulSwiftBundleIdentifier = "org.cocoapods.SoulSwift"
    static let soulSwiftName = "SoulSwift"
}

protocol SoulUserAgentProviderProtocol {
    func addUserAgent(_ request: URLRequest) -> URLRequest
}

class SoulUserAgentVersionProvider: SoulUserAgentProviderProtocol {

    func addUserAgent(_ request: URLRequest) -> URLRequest {
        var request = request
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        return request
    }

    private func getUserAgent() -> String {
        let appName = SoulClient.shared.soulConfiguration.appName
        let appVersion = stringFromBundle(for: Constants.bundleShortVersionStringKey) ?? "" // 1.2.3-production
        let systemName = UIDevice.current.systemName // iOS
        let systemVersion = UIDevice.current.systemVersion // 8.3
        let model = modelIdentifier() // iPhone 5S
        let buildVersion = stringFromBundle(for: Constants.bundleVersionKey) ?? "" // 1234
        let soulSwiftName = Constants.soulSwiftName // SoulSwift
        let soulSwiftVersion = stringFromBundle(bundleIdentifier: Constants.soulSwiftBundleIdentifier, for: Constants.bundleShortVersionStringKey) ?? "" // 1.2.3-production
        let language = NSLocale.current.identifier

        let userAgent = "\(appName)/\(corrected(appVersion)) (\(systemName) \(systemVersion); \(model); \(language); b\(buildVersion)) \(soulSwiftName)/\(corrected(soulSwiftVersion)) (\(systemName))"
        return userAgent
    }

    private func corrected(_ version: String) -> String {
        if let range = version.range(of: "-") {
            return version.substring(with: range)
        } else {
            return version
        }
    }

    private func stringFromBundle(bundleIdentifier: String? = nil, for key: String) -> String? {
        if let identifier = bundleIdentifier {
            return Bundle(identifier: identifier)?.object(forInfoDictionaryKey: key) as? String
        } else {
            return Bundle.main.object(forInfoDictionaryKey: key) as? String
        }
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
