import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var notificationsViewModel: NotificationsViewModel
    
    @StateObject private var feedCoordinator: NavigationCoordinator = NavigationCoordinator()
    @StateObject private var profileCoordinator: NavigationCoordinator = NavigationCoordinator()
    @StateObject private var notificationsCoordinator: NavigationCoordinator = NavigationCoordinator()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                NavigationStack(path: $feedCoordinator.path) {
                    FeedView()
                        .navigationTitle("Home")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .profile(let profileDid):
                                ProfileView(profileDid: profileDid)
                                    .environmentObject(feedCoordinator)
                            case .postThread(let uri):
                                PostThreadView(uri: uri)
                                    .environmentObject(profileCoordinator)
                            }
                        }
                        .environmentObject(feedCoordinator)
                }
            }
            if authViewModel.session != nil {
                Tab("Search", systemImage: "magnifyingglass", value: 1) {
                    
                }
                
                let notificationsBadge = notificationsViewModel.notifications?.filter {
                    !($0.isRead ?? false)
                }.count ?? 0
                
                Tab("Notifications", systemImage: "bell", value: 2) {
                    NavigationStack(path: $notificationsCoordinator.path) {
                        NotificationsView()
                            .environmentObject(notificationsCoordinator)
                            .environmentObject(notificationsViewModel)
                            
                    }
                }
                .badge(notificationsBadge)
                Tab("Account", systemImage: "person", value: 3) {
                    NavigationStack(path: $profileCoordinator.path) {
                        ProfileView(profileDid: authViewModel.session?.did)
                            .environmentObject(profileCoordinator)
                            .environmentObject(authViewModel)
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .profile(let profileDid):
                                    ProfileView(profileDid: profileDid)
                                        .environmentObject(profileCoordinator)
                                case .postThread(let uri):
                                    PostThreadView(uri: uri)
                                        .environmentObject(profileCoordinator)
                                }
                            }
                    }
                }.badge(Text("!"))
            }
            else {
                Tab("Settings", systemImage: "gearshape", value: 4) {
                    NavigationStack {
                        SettingsView()
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
