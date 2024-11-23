import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Inject private var blueskyService: BlueskyService
    
    @Published var isLoading: Bool = false
    @Published var profile: BlueskyProfileModel?
    
    @Published var feed: [FeedItemModel]? = nil
    private var cursor: String?
    
    @MainActor
    func initProfile(of userDid: String?, withLoading: Bool = true) async {
        defer {
            isLoading = false
        }
        if withLoading {
            isLoading = true
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
    
    func follow(from did: String) async {
        do {
            let _ = try await blueskyService.createRecord(record: CreateActionRecordDTO(collection: .follow, record: ActionRecordDTORecord(type: .follow, createdAt: Date.now, subject: .profile(profile?.did ?? "")), repo: did))
            
            await initProfile(of: profile?.did, withLoading: false)
        } catch {
            Logger.error("ProfileViewModel::follow:", error: error)
        }
    }
    
    func unfollow() async {
        if let (repo, recordKey) = parseAtURL(profile?.viewer?.following ?? "") {
            do {
                let payload = DeleteActionRecordDTO(collection: .follow, repo: repo, rkey: recordKey)
                let _ = try await blueskyService.deleteRecord(record: payload)
                await initProfile(of: profile?.did, withLoading: false)
            } catch {
                Logger.error("ProfileViewModel::unfollow:", error: error)
            }
        }
    }
    
    
}
