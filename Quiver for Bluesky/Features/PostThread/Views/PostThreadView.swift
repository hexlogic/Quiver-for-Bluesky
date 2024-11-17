import SwiftUI

struct PostThreadView: View {
    
    let uri: String?
    @StateObject private var viewModel = PostThreadViewModel()
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.isLoading {
                    ProgressView()
                }
                
                if let thread = viewModel.thread {
                    MainPostView(post: thread.post) { profileDid in
                        coordinator.navigate(to: .profile(profileDid: profileDid))
                    } onPostTap: { uri in
                        
                    }
                    Button("Write your reply") {
                        
                    }
                    Divider()
                    ForEach(viewModel.thread?.replies ?? []) { reply in
                        
                        ReplyView(reply: reply)
                    }
                }
                
            }
            .padding()
            .taskOnce {
                Task {
                    await viewModel.initPostThread(at: uri)
                }
            }
        }
    }
}

struct ReplyView: View {
    let reply: ReplyModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: reply.post?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .foregroundStyle(.orange.opacity(0.5))
                } placeholder: {
                    Color.gray
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .foregroundStyle(.orange.opacity(0.5))
                }
                VStack(alignment: .leading) {
                    Text("\(reply.post?.author?.displayName ?? "Unknown")")
                        .minimumScaleFactor(0.5)
                        .truncationMode(.middle)
                        .lineLimit(1)
                    Text("@\(reply.post?.author?.handle ?? "Unknown")")
                        .fontWeight(.thin)
                }
                
                Spacer()
                Text("\(timeAgo(from: convertDate(from: reply.post?.record?.createdAt) ?? Date()))")
                    .fontWeight(.light)
            }
            
            
            Text("\(reply.post?.record?.text ?? "Unknown")")
            
            PostActionsView(post: reply.post)
            
            
        }
    }
}


private func timeAgo(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .numeric
    formatter.unitsStyle = .abbreviated
    return formatter.localizedString(for: date, relativeTo: Date())
}

private func convertDate(from date: String?) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: date ?? "")
}
