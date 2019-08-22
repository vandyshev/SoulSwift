private enum Constants {
    static let bundleNameKey = "CFBundleName"
    static let bundleVersionKey = "CFBundleVersion"
    static let bundleShortVersionStringKey = "CFBundleShortVersionString"
    static let simulatorModelIdentifierKey = "SIMULATOR_MODEL_IDENTIFIER"
}

protocol SoulUserAgentProviderProtocol {
    func addUserAgent(_ request: URLRequest) -> URLRequest
}

struct SoulUserAgentVersionProvider: SoulUserAgentProviderProtocol {

    func addUserAgent(_ request: URLRequest) -> URLRequest {
        var request = request
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        return request
    }

    private func getUserAgent() -> String {
        let appName = SoulSwiftClient.shared.soulConfiguration.appName
        let appVersion = stringFromBundle(for: Constants.bundleShortVersionStringKey) ?? "" // 1.2.3-production
        let systemName = UIDevice.current.systemName // iOS
        let systemVersion = UIDevice.current.systemVersion // 8.3
        let model = modelIdentifier() // iPhone 5S
        let buildVersion = stringFromBundle(for: Constants.bundleVersionKey) ?? "" // 1234

        let correctedAppVersion: String = {
            // appVersion may have suffix, for example 1.2.3-production. We don't need it here
            if let range = appVersion.range(of: "-") {
                return appVersion.substring(with: range)
            }
            return appVersion
        }()

        let language = NSLocale.current.identifier

        // TODO: Добавить получение SoulSwift/1.0.0 из Info.plist
        // swiftlint:disable line_length
        let userAgent = "\(appName)/\(correctedAppVersion) (\(systemName) \(systemVersion); \(model); \(language); b\(buildVersion)) SoulSwift/1.0.0 (\(systemName))"
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
