public enum MessageEventType {
    case failed(messageId: String)
    case ack(messageId: String)
    case delivered(messageId: String)
    case read(timestamp: UnixTimeStamp)
}
