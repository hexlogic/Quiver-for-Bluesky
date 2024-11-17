import Foundation
import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var notifications: [NotificationModel]?
    @Published var posts: [PostModel]?
    
    private var timers: [Timer] = []
    
    
    @Inject private var blueskyService: BlueskyService
    
    init() {
        let timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { await self?.initNotifications() }
        }
        timers.append(timer)
    }
    
    deinit {
        timers.forEach { $0.invalidate() }
        timers.removeAll()
    }
    
    @MainActor
    func initNotifications() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let notifications = try await blueskyService.getListNotifications()
            if(notifications.notifications != self.notifications) {
                self.notifications = notifications.notifications
                let uris = notifications.notifications?.filter { notification in
                    notification.reasonSubject != nil
                }.map({ notification in
                    notification.reasonSubject!
                }) ?? []
                
                let posts = try await blueskyService.getPosts(uris: Array(Set(uris)))
                self.posts = posts.posts
            }
        } catch {
            Logger.error("NotificationsViewModel::initNotifications", error: error)
        }
    }
}
