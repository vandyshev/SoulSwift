import Foundation

enum Reaction: Equatable {
//    case liking(LikeReaction)
//    case Blocking(BlockReaction)
}

//func == (lhs: Reaction, rhs: Reaction) -> Bool {
//    switch (lhs, rhs) {
//    case let (.liking(reactionA), .liking(reactionB)):
//        return reactionA == reactionB
//    }
//}

struct EventReaction {
    var userId: String
//    var reactions: [Reaction]
}
