enum Endpoint {
    case createSession
    case refreshSession
    case getTimeline
    case createPost
    case getProfile
    case popularFeedGenerators
    case getFeed
    case getSession
    case deleteSession
    case createRecord
    case deleteRecord
    case getAuthorFeed
    case getPostThread
    case getListNotifications
    case getPosts
    
    var path: String {
        switch self {
            case .createSession: return "com.atproto.server.createSession"
            case .refreshSession: return "com.atproto.server.refreshSession"
            case .getTimeline: return "app.bsky.feed.getTimeline"
            case .createPost: return "com.atproto.repo.createRecord"
            case .getProfile: return "app.bsky.actor.getProfile"
            case .popularFeedGenerators: return "app.bsky.unspecced.getPopularFeedGenerators"
            case .getFeed: return "app.bsky.feed.getFeed"
            case .getSession: return "com.atproto.server.getSession"
            case .deleteSession: return "com.atproto.server.deleteSession"
            case .createRecord: return "com.atproto.repo.createRecord"
            case .deleteRecord: return "com.atproto.repo.deleteRecord"
            case .getAuthorFeed: return "app.bsky.feed.getAuthorFeed"
            case .getPostThread: return "app.bsky.feed.getPostThread"
            case .getListNotifications: return "app.bsky.notification.listNotifications"
            case .getPosts: return "app.bsky.feed.getPosts"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case authenticationRequired
    case serverError(ErrorResponse)
    case decodingError(Error)
    case networkError(Error)
    case unknownError
}
