import SwiftUI

struct ProfileView: View {
    private var profileDid: String?
    
    @State private var selectedFeed: AuthorFeedFilter = .postsAndAuthorThreads
    
    @StateObject private var viewModel: ProfileViewModel = .init()
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    init(profileDid: String? = nil) {
        if let profileDid = profileDid {
            self.profileDid = profileDid
        }
    }
    
    var isOwnAccount: Bool {
        profileDid == authViewModel.session?.did
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
                                        .foregroundStyle(.gray)
                                }
                                VStack {
                                    Text("\(viewModel.profile?.followsCount ?? 0)")
                                        .bold()
                                    Text("Following")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                VStack {
                                    Text("\(viewModel.profile?.followersCount ?? 0)")
                                        .bold()
                                    Text("Followers")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    Color.clear.frame(height: 8)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.profile?.displayName ?? "")
                                .bold()
                                .font(.system(size: .init(20)))
                            Text("@\(viewModel.profile?.handle ?? "")")
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        if !isOwnAccount {
                            
                                if viewModel.profile?.viewer?.following != nil {
                                    Button("Following") {
                                        Task {
                                            await viewModel.unfollow()
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                } else {
                                    Button("Follow") {
                                        Task {
                                            await viewModel.follow(from: authViewModel.session?.did ?? "")
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                        }
                    }
                    Text(viewModel.profile?.description ?? "")
                }
                .padding(.horizontal)
            }
            if viewModel.profile != nil {
                FeedSwitcherView(selectedFeed: $selectedFeed, profile: viewModel.profile!)
            }
           
//            Picker(selection: $selectedFeed) {
//                Text("Posts & Threads").tag(AuthorFeedFilter.postsAndAuthorThreads)
//                Text("Replies").tag(AuthorFeedFilter.postsWithReplies)
//                Text("Media").tag(AuthorFeedFilter.postsWithMedia)
//                if viewModel.profile?.associated?.feedgens != nil {
//                    Text("Feeds").tag(AuthorFeedFilter.feeds)
//                }
//                if viewModel.profile?.associated?.starterPacks != nil {
//                    Text("Starter Packs").tag(AuthorFeedFilter.starterPacks)
//                }
//                if viewModel.profile?.associated?.lists != nil {
//                    Text("Lists").tag(AuthorFeedFilter.lists)
//                }
//            } label: {
//                Text("Select the feed")
//            }
//            .pickerStyle(.menu)
//            .padding()
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

struct FeedSwitcherView: View {
    @Binding private var selectedFeed: AuthorFeedFilter
    private var profile: BlueskyProfileModel
    
    init(selectedFeed: Binding<AuthorFeedFilter>, profile: BlueskyProfileModel) {
        self._selectedFeed = selectedFeed
        self.profile = profile
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FeedSelectorButton(isSelected: selectedFeed == .postsAndAuthorThreads, filter: .postsAndAuthorThreads) {
                    selectedFeed = .postsAndAuthorThreads
                }
                FeedSelectorButton(isSelected: selectedFeed == .postsWithReplies, filter: .postsWithReplies) {
                    selectedFeed = .postsWithReplies
                }
                FeedSelectorButton(isSelected: selectedFeed == .postsWithMedia, filter: .postsWithMedia) {
                    selectedFeed = .postsWithMedia
                }
                
                if profile.associated?.feedgens != 0 {
                    FeedSelectorButton(isSelected: selectedFeed == .feeds, filter: .feeds) {
                        selectedFeed = .feeds
                    }
                }
                if profile.associated?.starterPacks != 0 {
                    FeedSelectorButton(isSelected: selectedFeed == .starterPacks, filter: .starterPacks) {
                        selectedFeed = .starterPacks
                    }
                }
                if profile.associated?.lists != 0 {
                    FeedSelectorButton(isSelected: selectedFeed == .lists, filter: .lists) {
                        selectedFeed = .lists
                    }
                }
            }
            .padding(.horizontal)
            
        }
    }
    
    struct FeedSelectorButton: View {
        let isSelected: Bool
        let filter: AuthorFeedFilter
        let onTap: () -> Void
        
        init(isSelected: Bool, filter: AuthorFeedFilter, onTap: @escaping () -> Void) {
            self.isSelected = isSelected
            self.filter = filter
            self.onTap = onTap
        }
        
        var body: some View {
            Button(action: {
                onTap()
            }) {
                Text(filter.getTitle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        isSelected ?
                        Color.accentColor :
                            Color.secondary.opacity(0.2)
                    )
                    .foregroundColor(
                        isSelected ?
                            .white :
                                .primary
                    )
                    .cornerRadius(20)
            }
        }
    }
}

