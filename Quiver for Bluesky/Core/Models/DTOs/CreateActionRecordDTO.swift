import Foundation

struct CreateActionRecordDTO: Encodable {
    let collection: ActionType
    let record: ActionRecordDTORecord
    let repo: String
    
    init(collection: ActionType, record: ActionRecordDTORecord, repo: String) {
        self.collection = collection
        self.record = record
        self.repo = repo
    }
}

struct ActionRecordDTORecord: Encodable {
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

enum SubjectModel: Encodable {
    case post(Post)
    case profile(String)
    
    enum CodingKeys: CodingKey {
        case cid, uri, type
    }
    
    func encode(to encoder: any Encoder) throws {
        switch self {
        case .post(let post):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(post.cid, forKey: .cid)
            try container.encode(post.uri, forKey: .uri)
        case .profile(let profile):
            var container = encoder.singleValueContainer()
            try container.encode(profile)
        }
    }
    
    struct Post: Codable {
        let cid: String?
        let uri: String?
        
        init(cid: String, uri: String) {
            self.cid = cid
            self.uri = uri
        }
    }
}

enum ActionType: String, Codable {
    case repost = "app.bsky.feed.repost"
    case like = "app.bsky.feed.like"
    case follow = "app.bsky.graph.follow"
}

