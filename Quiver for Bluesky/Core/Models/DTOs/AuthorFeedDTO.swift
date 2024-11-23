enum AuthorFeedFilter: String, CaseIterable {
    case postsWithReplies = "posts_with_replies"
    case postsWithMedia = "posts_with_media"
    case postsAndAuthorThreads = "posts_and_author_threads"
    case starterPacks
    case feeds
    case lists
    
    func getTitle() -> String {
        return switch self {
            case .postsWithReplies:
                "Posts & Replies"
            case .postsWithMedia:
                "Media"
            case .postsAndAuthorThreads:
                "Posts & Threads"
            case .starterPacks:
                "Starter Packs"
            case .feeds:
                "Feeds"
            case .lists:
                "Lists"
        }
    }
}
