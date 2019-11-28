public struct Reactions: Decodable {

    let sentByMe: Reaction?
    let receivedFromUser: Reaction?

    public struct Reaction: Decodable {

        let likes: Likes?

        // swiftlint:disable nesting
        public struct Likes: Decodable {
            let createdTime: TimeInterval?
            let expiresTime: TimeInterval?
            let value: LikeReaction?

            public enum LikeReaction: String, Decodable {
                case like = "liked"
                case dislike
                case neutral
                case instachat
            }
        }
    }

}
