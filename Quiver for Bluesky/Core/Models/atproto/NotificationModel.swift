import Foundation

struct NotificationModel: Codable, Identifiable, Equatable {
    let author: AuthorModel?
    let cid: String?
    let indexedAt: String?
    let isRead: Bool?
    let labels: [LabelModel]?
    let reason: String?
    let reasonSubject: String?
    let record: RecordModel?
    let uri: String?
    
    static func == (lhs: NotificationModel, rhs: NotificationModel) -> Bool {
        lhs.uri == rhs.uri
        && lhs.reason == rhs.reason
        && lhs.reasonSubject == rhs.reasonSubject
        && lhs.indexedAt == rhs.indexedAt
        && lhs.isRead == rhs.isRead
        && lhs.cid == rhs.cid
    }
    
    var id: UUID = UUID()
    
    enum CodingKeys: CodingKey {
        case author
        case cid
        case indexedAt
        case isRead
        case labels
        case reason
        case reasonSubject
        case record
        case uri
    }
}

struct NotificationsResponse: Codable {
    let notifications: [NotificationModel]?
    let priority: Bool?
    let seenAt: String?
}
