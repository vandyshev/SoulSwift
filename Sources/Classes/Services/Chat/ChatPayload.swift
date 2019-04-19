import UIKit

struct MessagePayload {
    let channel: String
    let message: ChatMessage
}

struct ChatMessage {
    let messageId: String  /// `id`  - message unique identifier
    let userId: String     /// `u`   - message creator identifer
    let timestamp: Int     /// `t`   - unix timestamp // TODO: check that it is
    let message: String    /// `m`   - message content
    let photoId: String?   /// `p`   - photo id
    let albumName: String? /// `pa`  - album name
    let latitude: Double?  /// `lat` - latitude
    let longitude: Double? /// `lng` - longitude
}
