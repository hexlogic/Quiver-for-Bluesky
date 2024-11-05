import SwiftUI
import OSLog

struct FeedView: View {
    @ObservedObject private var viewModel = FeedViewModel(service: BlueskyService(network: NetworkClient(authManager: AuthenticationManager())))
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.error != nil {
                Text(viewModel.error!.localizedDescription)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        let posts = viewModel.feed?.feed ?? []
                        ForEach(posts) { post in
                            FeedPostView(feedItem: post)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFeed()
            }
        }
        

    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
    .tint(.orange)
}

struct FeedPostView: View {
    
    let feedItem: FeedItemModel
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func convertDate(from date: String?) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: date ?? "")
    }
    
    var body: some View {

        VStack(alignment: .leading) {
            Color.clear.frame(height: 0)
            HStack {
                Color.clear.frame(width: 40)
                Text("Reposted by Anne Doe")
                    .font(.caption)
            }
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: feedItem.post?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundStyle(.orange.opacity(0.5))
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.orange.opacity(0.5))
                }
                    
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(feedItem.post?.author?.displayName ?? "Unknown")")
                            .font(.headline)
                        Spacer()
                        Text("\(timeAgo(from: convertDate(from: feedItem.post?.record?.createdAt) ?? Date()))")
                            .font(.headline)
                            .fontWeight(.light)
                    }
                    Text("\(feedItem.post?.record?.text ?? "Unknown")")
                    
                    if feedItem.post?.embed?.images != nil {
                        ImageCarousel(images: feedItem.post!.embed!.images!)
                    }
                    
                    if feedItem.post?.embed?.externalBSViewModel != nil {
                        LinkPreviewView(
                            external: feedItem.post?.embed?.externalBSViewModel
                        )
                    }
                    
                }
            }
            ActionsView(feedItem: feedItem)
            Color.clear.frame(height: 0)
        }
        
    }
}

struct ImageCarousel: View {
    let images: [EmbedImageModel]
    
    var body: some View {
        let count = images.count
        PhotoCarousel(imageUrls: images.map { URL(string: $0.fullsize ?? "https://via.placeholder.com/40x40")! })

        
    }
}

struct LinkPreviewView: View {
    let external: ExternalBSViewModel?
    @Environment(\.openURL) var openURL
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                // If image exists
                if(external?.thumb != nil)
                {
                    AsyncImage(url: URL(string: external!.thumb!)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }

                VStack(alignment: .leading) {
                    Text("\(external?.title ?? "")")
                        .font(.headline)
                        .lineLimit(1...10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(URL(string: external?.uri ?? "")?.host() ?? "")
                        .font(.caption)
                }
                .padding(8)
            }
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
            if let url = URL(string: external?.uri ?? "") {
                openURL(url)
            }
        }
        
    }
}

struct ActionsView: View {
    let feedItem: FeedItemModel
    var body: some View {
        VStack {
            Color.clear.frame(height: 4)
            
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "bubble")
                    Text("\(feedItem.post?.replyCount ?? 0)")
                }
                HStack {
                    Image(systemName: "repeat")
                    Text("\(feedItem.post?.repostCount ?? 0)")
                }
                HStack {
                    Image(systemName: "heart")
                    Text("\(feedItem.post?.likeCount ?? 0)")
                }
                Image(systemName: "ellipsis")
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct PhotoCarousel: View {
    let imageUrls: [URL]  // Array of image URLs
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<imageUrls.count, id: \.self) { index in
                    AsyncImage(url: imageUrls[index]) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.gray.opacity(0.1))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            Image(systemName: "photo.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.gray.opacity(0.1))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 300)
        }
    }
}
