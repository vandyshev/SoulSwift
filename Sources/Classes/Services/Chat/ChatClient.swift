import Foundation

protocol ChatClient {
    func connect()
    func sendMessage(_ messagePayload: MessagePayload) -> Bool // TODO: use decodable instead
}
