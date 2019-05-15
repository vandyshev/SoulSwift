import Foundation

/// This class helps to observe application status
protocol AppStatusObserver: AnyObject {
    var isApplicationActive: Bool { get }
    var onAppDidBecomeActive: (() -> Void)? { get set }
}

final class AppStatusObserverImpl: AppStatusObserver {

    var isApplicationActive: Bool {
        return UIApplication.shared.applicationState == .active
    }

    var onAppDidBecomeActive: (() -> Void)?

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    @objc private func didBecomeActive() {
        onAppDidBecomeActive?()
    }
}
