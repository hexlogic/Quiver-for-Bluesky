import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var feed: FeedResponseModel? = nil
    @Published var error: NetworkError?
    @Published var isLoading: Bool = false
    
    private let service: BlueskyService
    
    init(service: BlueskyService) {
        self.service = service
    }
    
    @MainActor
    func fetchFeed() async {
        isLoading = true
        
        do {
            let feedGenerators = try await service.getPopularFeedGenerators()
            feed = try await service.getFeed(uri: feedGenerators.feeds.first?.uri ?? "")
            isLoading = false
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
        
    }
}
