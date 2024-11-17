import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                let notifications = notificationsViewModel.notifications ?? []
                ForEach(notifications) { notification in
                    if notification.record?.type == "app.bsky.graph.follow" {
                        FollowNotificationView(notification: notification)
                    }
                    
                    if notification.record?.type == "app.bsky.feed.like" {
                        LikeNotificationView(notification: notification, post: notificationsViewModel.posts?.first(where: { post in
                            post.uri == notification.reasonSubject
                        }))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Notifications")
    }
}

struct LikeNotificationView : View {
    let notification: NotificationModel?
    let post: PostModel?
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                Image(systemName: "heart.fill")
                    .foregroundStyle(.orange)
                    .frame(width:40, height: 40)
                
                AsyncImage(url: URL(string: notification?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
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
                Spacer()
                Text("\(TimeAgo.timeAgo(from: TimeAgo.convertDate(from: notification?.record?.createdAt) ?? Date()))")
                    .font(.caption)
                    .fontWeight(.light)
            }
            HStack {
                Color.clear
                    .frame(width:40, height: 40)
                VStack(alignment: .leading) {
                    HStack {
                        if notification?.author?.displayName?.isEmpty ?? false {
                            Text("\(notification?.author?.handle ?? "Unknown")")
                                .bold()
                                .lineLimit(1)
                        } else {
                            Text("\(notification?.author?.displayName ?? notification?.author?.handle ?? "Unknown")")
                                .bold()
                                .lineLimit(1)
                        }
                        
                        Text("liked your post.")
                        
                    }
                    Text("\(post?.record?.text ?? "Unknown")")
                        .foregroundStyle(.gray)
                }

            }
        }
    }
}

struct FollowNotificationView: View {
    let notification: NotificationModel?
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                Image(systemName: "person.badge.plus")
                    .foregroundStyle(.orange)
                    .frame(width:40, height: 40)
                AsyncImage(url: URL(string: notification?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
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
                Spacer()
                Text("\(TimeAgo.timeAgo(from: TimeAgo.convertDate(from: notification?.record?.createdAt) ?? Date()))")
                    .font(.caption)
                    .fontWeight(.light)
                
            }
            HStack {
                Color.clear
                    .frame(width:40, height: 40)
                if notification?.author?.displayName?.isEmpty ?? false {
                    Text("\(notification?.author?.handle ?? "Unknown")")
                        .bold()
                        .lineLimit(1)
                } else {
                    Text("\(notification?.author?.displayName ?? notification?.author?.handle ?? "Unknown")")
                        .bold()
                        .lineLimit(1)
                }
                
                Text("followed you.")
                
            }
        }
    }
}
