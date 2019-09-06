import UIKit

/// It handles local push notifications
protocol ChatLocalPushManagerProtocol: AnyObject {
    var isEnabled: Bool { get set }
}

private enum Constants {
    static let maxLenght = 70
}

private enum LocalizationConstants {
    static let textMessage = "chat_message_text"
    static let photoMessage = "chat_message_photo"
    static let geoMessage = "chat_message_location"
}

class ChatLocalPushManager: ChatLocalPushManagerProtocol {

    var isEnabled: Bool = true

    private let chatServiceObserver: ChatServiceObserverProtocol
    private let localPushService: LocalPushServiceProtocol

    init(chatServiceObserver: ChatServiceObserverProtocol, localPushService: LocalPushServiceProtocol) {
        self.chatServiceObserver = chatServiceObserver
        self.localPushService = localPushService

        chatServiceObserver.subscribeToAllMessages(observer: self) { [weak self] messagePayload in
            guard self?.isEnabled == true else { return }
            let pushPayload = ChatLocalPushManager.createPushPayload(from: messagePayload)
            self?.localPushService.sendLocalPush(with: pushPayload)
        }
    }

    deinit {
        chatServiceObserver.unsubscribeFromAllMessages(observer: self)
    }

    private static func createPushPayload(from messagePayload: MessagePayload) -> PushPayload {
        let message = messagePayload.message
        let bodyKey: String
        if message.isPhotoMessage {
            bodyKey = LocalizationConstants.photoMessage
        } else if message.isLocationMessage {
            bodyKey = LocalizationConstants.geoMessage
        } else {
            bodyKey = LocalizationConstants.textMessage
        }
        let body = NSLocalizedString(bodyKey, comment: "")
        return PushPayload(body: body, userInfo: [:])
    }
}
