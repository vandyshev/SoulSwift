import UIKit

public protocol ChatService {

}

final class ChatServiceImpl: ChatService {

    private let chatServiceObserver: ChatServiceObserver
    private let chatServiceMessageSender: ChatServiceMessageSender

    init(chatServiceObserver: ChatServiceObserver, chatServiceMessageSender: ChatServiceMessageSender) {
        self.chatServiceObserver = chatServiceObserver
        self.chatServiceMessageSender = chatServiceMessageSender
    }
}
