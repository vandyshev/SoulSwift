public struct Reactions: Decodable {

    public var sentByMe: Reaction?
    public var receivedFromUser: Reaction?
    public var user: User?

    public init(sentByMe: Reaction? = nil,
                receivedFromUser: Reaction? = nil,
                user: User? = nil) {
        self.sentByMe = sentByMe
        self.receivedFromUser = receivedFromUser
        self.user = user
    }

    // swiftlint:disable nesting
    public struct Reaction: Decodable {

        public var likes: Likes?
        public var blocking: Blocking?

        public init(likeReaction: LikeReaction? = nil,
                    blockReaction: BlockReaction? = nil) {
            self.likes = Likes(createdTime: nil, expiresTime: nil, value: likeReaction)
            self.blocking = Blocking(createdTime: nil, expiresTime: nil, value: blockReaction)
        }

        public struct Likes: Decodable {
            public var createdTime: TimeInterval?
            public var expiresTime: TimeInterval?
            public var value: LikeReaction?
        }

        public struct Blocking: Decodable {
            public var createdTime: TimeInterval?
            public var expiresTime: TimeInterval?
            public var value: BlockReaction?
        }

        public enum LikeReaction: String, Decodable {
            case like = "liked"
            case dislike
            case neutral
            case instachat
        }

        public enum BlockReaction: String, Decodable {
            case block
        }
    }

    public struct User: Decodable {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
