import SwiftUI

struct PostActionsView: View {
    let post: PostModel?
    
    @StateObject var postActionViewModel: PostActionsViewModel = .init()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var likeCount: Int
    @State private var repostCount: Int
    
    
    init(post: PostModel?) {
        self.post = post
        
        self._likeCount = State(initialValue: post?.likeCount ?? 0)
        self._repostCount = State(initialValue: post?.repostCount ?? 0)
    }
    
    var body: some View {
        VStack {
            Color.clear.frame(height: 4)
            
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "bubble")
                    Text("\(post?.replyCount ?? 0)")
                }
                Spacer()
                HStack {
                    if postActionViewModel.repost != nil {
                        Image(systemName: "repeat")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "repeat")
                    }
                    Text("\(repostCount)")
                }
                .onTapGesture {
                    let isReposting = postActionViewModel.repost == nil
                    Task {
                        if isReposting {
                            await postActionViewModel.repost(postUri: post?.uri ?? "", postCid: post?.cid ?? "", userDid: authViewModel.session?.did ?? "")
                        } else {
                            await postActionViewModel.removeRepost()
                        }
                    }
                    repostCount += isReposting ? 1 : -1
                }
                Spacer()
                HStack {
                    if postActionViewModel.like != nil {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    } else {
                        Image(systemName: "heart")
                    }
                    
                    Text("\(likeCount)")
                }
                .onTapGesture {
                    let isLiking = postActionViewModel.like == nil
                    Task {
                        if isLiking {
                            await postActionViewModel.likePost(postUri: post?.uri ?? "", postCid: post?.cid ?? "", userDid: authViewModel.session?.did ?? "")
                        } else {
                            await postActionViewModel.removeLike()
                        }
                    }
                    withAnimation {
                        likeCount += isLiking ? 1 : -1
                    }
                }
                Spacer()
                Image(systemName: "ellipsis")
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                postActionViewModel.initActions(like: post?.viewer?.like, repost: post?.viewer?.repost)
                
            }
        }
    }
}
