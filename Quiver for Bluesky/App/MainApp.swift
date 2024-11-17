import SwiftUI


@main
struct MainApp: App {
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var notificationsViewModel: NotificationsViewModel
    
    init() {
        DependencyContainer.shared.register(BlueskyService(network: NetworkClient()))
        _authViewModel = StateObject(wrappedValue: AuthViewModel())
        _notificationsViewModel = StateObject(wrappedValue: NotificationsViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(.orange)
                .environmentObject(authViewModel)
                .environmentObject(notificationsViewModel)
                .task {
                    await authViewModel.silentLogin()
                    await notificationsViewModel.initNotifications()
                }
        }
    }
}
