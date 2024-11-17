import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var feed: [FeedItemModel]? = nil
    private var cursor: String?
    private var feedUri: String?
    @Published var error: NetworkError?
    @Published var isLoading: Bool = false
    
    @Inject private var service: BlueskyService
    
    func cleanState() {
        cursor = nil
        feedUri = nil
        error = nil
    }
    
    @MainActor
    func initFeed(isRefreshing: Bool, feedUri: String? = nil) async {
        if !isRefreshing {
            isLoading = true            
        }
        do {
            cleanState()
            if let feedUri {
                self.feedUri = feedUri
                let feedResult = try await retryOnNetworkErrors {
                    try await service.getFeed(uri: self.feedUri ?? "", cursor: nil)
                }
                feed = feedResult.feed
                cursor = feedResult.cursor
            } else {
                
                let accessToken = try? TokenManager.getAccessToken()
                
                if accessToken == nil {
                    let feedGenerators = try await retryOnNetworkErrors {
                        try await service.getPopularFeedGenerators()
                    }
                    
                    
                    self.feedUri = feedGenerators.feeds.first?.uri
                    let feedResult = try await retryOnNetworkErrors {
                        try await service.getFeed(uri: self.feedUri ?? "", cursor: nil)
                    }
                    feed = feedResult.feed
                    cursor = feedResult.cursor
                } else {
                    let feedResult = try await retryOnNetworkErrors {
                        try await service.getTimeline(cursor: nil)
                    }
                    feed = feedResult.feed
                    cursor = feedResult.cursor
                }
                
                
            }
            
            isLoading = false
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
    }
    
    @MainActor
    func loadNextIfNeeded(feedItem: FeedItemModel) async {
        let indexOf = feed?.firstIndex(of: feedItem) ?? 0
        if indexOf <= (feed?.count ?? 0) - 2 {
            return
        }
        do {
            if self.feedUri != nil {
                let feedResult = try await service.getFeed(uri: feedUri ?? "", cursor: self.cursor)
                feed?.append(contentsOf: feedResult.feed ?? [])
                cursor = feedResult.cursor
            } else {
                let feedResult = try await service.getTimeline(cursor: self.cursor)
                feed?.append(contentsOf: feedResult.feed ?? [])
                cursor = feedResult.cursor
            }
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
    }
}
