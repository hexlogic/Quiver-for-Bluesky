import Foundation
import SwiftUI

class PostActionsViewModel: ObservableObject {
    @Inject private var blueskyService: BlueskyService
    
    @Published var like: String?
    @Published var repost: String?
    
    func initActions(like: String?, repost: String?) {
        self.like = like
        self.repost = repost
    }
    
    @MainActor
    func likePost(postUri: String, postCid: String, userDid: String) async {
        let payload = CreateActionRecordDTO(collection: .like, record: ActionRecordDTORecord(type: .like, createdAt: Date.now, subject: SubjectModel(cid: postCid, uri: postUri)), repo: userDid)
        
        
        let response = try? await blueskyService.createRecord(record: payload)
        withAnimation {
            like = response?.uri
        }
        
    }
    
    @MainActor
    func repost(postUri: String, postCid: String, userDid: String) async {
        let payload = CreateActionRecordDTO(collection: .repost, record: ActionRecordDTORecord(type: .repost, createdAt: Date.now, subject: SubjectModel(cid: postCid, uri: postUri)), repo: userDid)
        
        let response = try? await blueskyService.createRecord(record: payload)
        withAnimation {
            repost = response?.uri
        }
    }
    
    @MainActor
    func removeLike() async {
        if let (repo, recordKey) = parseAtURL(like ?? "") {
            let payload = DeleteActionRecordDTO(collection: .like, repo: repo, rkey: recordKey)
            let _ = try? await blueskyService.deleteRecord(record: payload)
            withAnimation {
                like = nil
            }
        }
        
    }
    
    @MainActor
    func removeRepost() async {
        if let (repo, recordKey) = parseAtURL(repost ?? "") {
            let payload = DeleteActionRecordDTO(collection: .repost, repo: repo, rkey: recordKey)
            let _ = try? await blueskyService.deleteRecord(record: payload)
            withAnimation {
                repost = nil
            }
        }
        
    }
    
    func parseAtURL(_ url: String) -> (did: String, recordKey: String)? {
        let withoutPrefix = url.replacingOccurrences(of: "at://", with: "")
        let components = withoutPrefix.components(separatedBy: "/")
        
        guard components.count >= 3 else { return nil }
        return (did: components[0], recordKey: components[2])
    }
}
