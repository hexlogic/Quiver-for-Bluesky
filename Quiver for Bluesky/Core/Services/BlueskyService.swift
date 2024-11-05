class BlueskyService {
    private let network: NetworkClientProtocol
    
    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func getPopularFeedGenerators() async throws -> FeedGeneratorsModel {
        let response: FeedGeneratorsModel = try await network.request(endpoint: .popularFeedGenerators, method: .get, queryParameters: [:], body: nil)
        return response
    }
    
    func getFeed(uri: String) async throws -> FeedResponseModel {
        let response: FeedResponseModel = try await network.request(endpoint: .getFeed(uri: uri), method: .get, queryParameters: ["feed": "\(uri)", "limit": 100], body: nil)
        return response
    }
}
