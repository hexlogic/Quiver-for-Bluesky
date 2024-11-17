import Foundation

class BlueskyService: Service {
    private let network: NetworkClientProtocol
    
    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func getPopularFeedGenerators() async throws -> FeedGeneratorsModel {
        let response: FeedGeneratorsModel = try await network.request(endpoint: .popularFeedGenerators, method: .get, queryParameters: [:], body: nil)
        return response
    }
    
    func getFeed(uri: String, cursor: String?) async throws -> FeedResponseModel {
        var queryParameters: [String: Any] = [
            "feed": "\(uri)",
            "limit": 10,
        ]
        
        if let cursor {
            queryParameters["cursor"] = cursor
        }
        
        let response: FeedResponseModel = try await network.request(endpoint: .getFeed, method: .get, queryParameters: queryParameters, body: nil)
        return response
    }
    
    func createSession(loginDTO: LoginDTO) async throws -> SessionModel {
        let response: SessionModel = try await network.request(endpoint: .createSession, method: .post, queryParameters: [:], body: loginDTO)
        return response
    }
    
    func getSession() async throws -> SessionModel {
        let response: SessionModel = try await network.request(endpoint: .getSession, method: .get, queryParameters: [:], body: nil)
        return response
    }
    
    func deleteSession() async throws {
        let _: String = try await network.request(endpoint: .deleteSession, method: .post, queryParameters: [:], body: nil)
    }
    
    func refreshSession() async throws -> SessionModel {
        let response: SessionModel = try await network.request(endpoint: .refreshSession, method: .post, queryParameters: [:], body: nil)
        return response
    }
    
    func getProfile(profileDid: String) async throws -> BlueskyProfileModel {
        let response: BlueskyProfileModel = try await network.request(endpoint: .getProfile, method: .get, queryParameters: ["actor" : profileDid], body: nil)
        return response
    }
    
    func getTimeline(cursor: String? = nil) async throws -> FeedResponseModel {
        var queryParameters: [String: Any] = [:]
        if let cursor {
            queryParameters["cursor"] = cursor
        }
        let response: FeedResponseModel = try await network.request(endpoint: .getTimeline, method: .get, queryParameters: queryParameters, body: nil)
        return response
    }
    
    func createRecord(record: CreateActionRecordDTO) async throws -> ActionRecordResponseModel {
        let response: ActionRecordResponseModel = try await network.request(endpoint: .createRecord, method: .post, queryParameters: [:], body: record)
        return response
    }
    
    func deleteRecord(record: DeleteActionRecordDTO) async throws -> ActionCommitModel {
        let response: ActionCommitModel = try await network.request(endpoint: .deleteRecord, method: .post, queryParameters: [:], body: record)
        return response
    }
    
    func getAuthorFeed(actor: String, cursor: String? = nil, filter: AuthorFeedFilter) async throws -> FeedResponseModel {
        var queryParameters: [String: Any] = [
            "actor": actor,
            "filter": filter.rawValue
        ]
        if let cursor = cursor {
            queryParameters["cursor"] = cursor
        }
        let response: FeedResponseModel = try await network.request(endpoint: .getAuthorFeed, method: .get, queryParameters: queryParameters, body: nil)
        return response
    }
    
    func getPostThread(at uri: String?) async throws -> ThreadResponseModel {
        var queryParamenters: [String: Any] = [:]
        if let uri {
            queryParamenters["uri"] = uri
        }
        let response: ThreadResponseModel = try await network.request(endpoint: .getPostThread, method: .get, queryParameters: queryParamenters, body: nil)
        return response
    }
    
    func getListNotifications(limit: Int = 40) async throws -> NotificationsResponse {
        var queryParameters: [String: Any] = [:]
        queryParameters["limit"] = limit
        
        let response: NotificationsResponse = try await network.request(endpoint: .getListNotifications, method: .get, queryParameters: queryParameters, body: nil)
        return response
    }
    
    func getPosts(uris: [String]) async throws -> PostsResponseModel {
        var queryParameters: [String: Any] = [:]
        
        queryParameters["uris"] = uris
        
        let response: PostsResponseModel = try await network.request(endpoint: .getPosts, method: .get, queryParameters: queryParameters, body: nil)
        return response
    }
}

