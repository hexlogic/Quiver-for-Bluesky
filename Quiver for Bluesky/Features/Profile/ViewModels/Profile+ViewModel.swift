import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Inject private var blueskyService: BlueskyService
    
    @Published var isLoading: Bool = false
    @Published var profile: BlueskyProfileModel?
    
    @Published var feed: [FeedItemModel]? = nil
    private var cursor: String?
    
    @MainActor
    func initProfile(of userDid: String?) async {
        isLoading = true
        defer {
            isLoading = false
        }
        if let userDid = userDid {
            do {
                self.profile = try await blueskyService.getProfile(profileDid: userDid)
            } catch {
                Logger.error("ProfileViewModel::initProfile:", error: error)
            }
        }
    }
    
    @MainActor
    func initFeed(feedFilter: AuthorFeedFilter) async {
        do {
            let feedResult = try await retryOnNetworkErrors {
                try await blueskyService.getAuthorFeed(actor: profile?.did ?? "", filter: feedFilter)
            }
            feed = feedResult.feed
            cursor = feedResult.cursor
        } catch {
            Logger.error("ProfileViewModel::initFeed:", error: error)
        }
    }
    
    @MainActor
    func loadFeedNextIfNeeded(feedItem: FeedItemModel, feedFilter: AuthorFeedFilter) async {
        let indexOf = feed?.firstIndex(of: feedItem) ?? 0
        if indexOf <= (feed?.count ?? 0) - 2 || cursor == nil {
            return
        }
        do {

            let feedResult = try await blueskyService.getAuthorFeed(actor: profile?.did ?? "", cursor: self.cursor, filter: feedFilter)
                feed?.append(contentsOf: feedResult.feed ?? [])
                cursor = feedResult.cursor
        
        }catch {
            Logger.error("ProfileViewModel::loadFeedNextIfNeeded:", error: error)
        }
    }
}
