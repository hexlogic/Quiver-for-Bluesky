import SwiftUI
import OSLog

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var hasAppeared = false
    
    @State private var newPostSheet = false
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    private var feedUri: String?
    
    init(feedUri: String? = nil) {
        self.feedUri = feedUri
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    let posts = viewModel.feed ?? []
                    ForEach(posts) { post in
                        FeedThreadView(feedItem: post) { profileDid in
                            coordinator.navigate(to: .profile(profileDid: profileDid))
                        } onPostTap: { uri in
                            coordinator.navigate(to: .postThread(uri: uri))
                        }
                        .onAppear {
                            Task {
                                await viewModel.loadNextIfNeeded(feedItem: post)
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        newPostSheet = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            })
            .sheet(isPresented: $newPostSheet) {
                NewPostView() {
                    Task {
                        await viewModel.initFeed(isRefreshing: false)
                    }
                }
            }
            .refreshable {
                Task {
                    await viewModel.initFeed(isRefreshing: true)
                }
            }
        }
        .taskOnce {
            Task {
                await viewModel.initFeed(isRefreshing: false)
            }
        }
        .environmentObject(coordinator)
    }
}

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func goToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case profile(profileDid: String)
    case postThread(uri: String)
}
