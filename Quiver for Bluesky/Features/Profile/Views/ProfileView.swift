import SwiftUI

struct ProfileView: View {
    private var profileDid: String?
    
    @State private var selectedFeed: AuthorFeedFilter = .postsAndAuthorThreads
    
    @StateObject private var viewModel: ProfileViewModel = .init()
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    init(profileDid: String? = nil) {
        if let profileDid = profileDid {
            self.profileDid = profileDid
        }
    }
    
    var body: some View {
        if viewModel.isLoading {
            VStack {
                ProgressView()
            }
        }
        ScrollView {
            ZStack {
                VStack {
                    if let banner = viewModel.profile?.banner {
                        AsyncImage(url: URL(string: banner)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 150)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Color.clear.frame(height: 95)
                        .ignoresSafeArea(.all)
                    HStack {
                        AsyncImage(url: URL(string: viewModel.profile?.avatar ?? "https://via.placeholder.com/40x40")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 100, height: 100)
                        Spacer()
                        VStack {
                            Spacer()
                            HStack {
                                VStack {
                                    Text("\(viewModel.profile?.postsCount ?? 0)")
                                        .bold()
                                    Text("Posts")
                                        .font(.caption)
                                }
                                VStack {
                                    Text("\(viewModel.profile?.followsCount ?? 0)")
                                        .bold()
                                    Text("Following")
                                        .font(.caption)
                                }
                                VStack {
                                    Text("\(viewModel.profile?.followersCount ?? 0)")
                                        .bold()
                                    Text("Followers")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    Color.clear.frame(height: 8)
                    Text(viewModel.profile?.displayName ?? "")
                        .bold()
                        .font(.system(size: .init(20)))
                    Text("@\(viewModel.profile?.handle ?? "")")
                    Spacer()
                }
                .padding(.horizontal)
            }
            Picker(selection: $selectedFeed) {
                Text("Posts & Threads").tag(AuthorFeedFilter.postsAndAuthorThreads)
                Text("Replies").tag(AuthorFeedFilter.postsWithReplies)
                Text("Media").tag(AuthorFeedFilter.postsWithMedia)
            } label: {
                Text("Select the feed")
            }
            .pickerStyle(.segmented)
            .padding()
            LazyVStack {
                let posts = viewModel.feed ?? []
                ForEach(posts) { post in
                    FeedThreadView(feedItem: post) { profileDid in
                        coordinator.navigate(to: .profile(profileDid: profileDid))
                    } onPostTap: { uri in
                        coordinator.navigate(to: .postThread(uri: uri))
                    }
                        .onAppear {
                            Task {
                                await viewModel.loadFeedNextIfNeeded(feedItem: post, feedFilter: selectedFeed)
                            }
                        }
                }
            }
            .padding()
        }
        
        .onChange(of: selectedFeed) {
            Task {
                await viewModel.initFeed(feedFilter: selectedFeed)
            }
        }
        
        .onAppear {
            Task {
                await viewModel.initProfile(of: profileDid)
                await viewModel.initFeed(feedFilter: selectedFeed)
            }
        }
    }
}


