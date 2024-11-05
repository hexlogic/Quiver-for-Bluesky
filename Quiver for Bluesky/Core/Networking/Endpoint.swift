enum Endpoint {
    case createSession(identifier: String, password: String)
    case refreshSession(refreshJwt: String)
    case getTimeline
    case createPost(text: String)
    case getProfile(actor: String)
    case popularFeedGenerators
    case getFeed(uri: String)
    
    var path: String {
        switch self {
            case .createSession: return "com.atproto.server.createSession"
            case .refreshSession: return "com.atproto.server.refreshSession"
            case .getTimeline: return "app.bsky.feed.getTimeline"
            case .createPost: return "com.atproto.repo.createRecord"
            case .getProfile: return "app.bsky.actor.getProfile"
            case .popularFeedGenerators: return "app.bsky.unspecced.getPopularFeedGenerators"
            case .getFeed: return "app.bsky.feed.getFeed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getTimeline, .getProfile, .popularFeedGenerators, .getFeed: return .get
            case .createPost, .createSession, .refreshSession: return .post
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
    case serverError(String)
    case decodingError(Error)
    case networkError(Error)
}
