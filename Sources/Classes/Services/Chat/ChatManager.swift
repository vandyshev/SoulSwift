import Foundation

protocol ChatManager {
    func history(channel: String, olderThan: Date, completion: (Result<[Message], Error>) -> Void)
    func sendMessage(to channel: String, text: String, completion: (Result<Message, Error>) -> Void)
    func subscribe(to channel: String, )
    
}
