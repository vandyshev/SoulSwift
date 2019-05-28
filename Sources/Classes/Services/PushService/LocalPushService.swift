import Foundation
import UserNotifications

struct PushPayload {

    /// Push identifier
    let identifier: String

    /// Push title (available after iOS 8.2)
    let title: String?

    /// Push body
    let body: String

    /// User info for data like url
    let userInfo: [String: String]?

    /// Default init
    init(identifier: String, title: String, body: String, userInfo: [String: String]?) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.userInfo = userInfo
    }

    /// Init what uses random identifier
    init(title: String? = nil, body: String, userInfo: [String: String]?) {
        self.identifier = UUID().uuidString
        self.title = title
        self.body = body
        self.userInfo = userInfo
    }
}

/// Sends local push notifications
protocol LocalPushService {
    func sendLocalPush(with payload: PushPayload)
}

@available (iOS 10, *)
class LocalPushServiceImpl: LocalPushService {

    func sendLocalPush(with payload: PushPayload) {
        let content = UNMutableNotificationContent()
        if let title = payload.title {
            content.title = title
        }
        content.body = payload.body
        content.sound = UNNotificationSound.default
        if let userInfo = payload.userInfo {
            content.userInfo = userInfo
        }

        let request = UNNotificationRequest(identifier: payload.identifier,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

@available(iOS, deprecated:10.0, message:"Use generateContactInfo()")
class LocalPushServiceOldImpl: LocalPushService {

    func sendLocalPush(with payload: PushPayload) {
        let notification = UILocalNotification()
        if #available(iOS 8.2, *), let title = payload.title {
            notification.alertTitle = title
        }
        notification.alertBody = payload.body
        notification.soundName = UILocalNotificationDefaultSoundName
        if let userInfo = payload.userInfo {
            notification.userInfo = userInfo
        }
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
