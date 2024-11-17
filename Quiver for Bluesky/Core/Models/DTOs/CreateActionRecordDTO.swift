import Foundation

struct CreateActionRecordDTO: Codable {
    let collection: ActionType
    let record: ActionRecordDTORecord
    let repo: String
    
    init(collection: ActionType, record: ActionRecordDTORecord, repo: String) {
        self.collection = collection
        self.record = record
        self.repo = repo
    }
}

struct ActionRecordDTORecord: Codable {
    let type: ActionType
    @ISO8601Date var createdAt: Date
    let subject: SubjectModel
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case createdAt
        case subject
    }
    
    init(type: ActionType, createdAt: Date, subject: SubjectModel) {
        self.type = type
        self.createdAt = createdAt
        self.subject = subject
    }
}

struct SubjectModel: Codable {
    let cid: String?
    let uri: String?
    
    init(cid: String, uri: String) {
        self.cid = cid
        self.uri = uri
    }
}

enum ActionType: String, Codable {
    case repost = "app.bsky.feed.repost"
    case like = "app.bsky.feed.like"
}

