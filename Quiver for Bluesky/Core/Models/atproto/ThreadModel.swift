import Foundation

struct ThreadResponseModel: Codable {
    let thread: ThreadModel?
}

struct ThreadModel: Codable {
    let type: String?
    let post: PostModel?
    let replies: [ReplyModel]?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case post
        case replies
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.post = try container.decodeIfPresent(PostModel.self, forKey: .post)
        self.replies = try container.decodeIfPresent([ReplyModel].self, forKey: .replies)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(post, forKey: .post)
        try container.encodeIfPresent(replies, forKey: .replies)
    }
}

struct ReplyModel: Codable, Identifiable {
    let type: String?
    let post: PostModel?
    let replies: [ReplyModel]?
    let id: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case post
        case replies
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.post = try container.decodeIfPresent(PostModel.self, forKey: .post)
        self.replies = try container.decodeIfPresent([ReplyModel].self, forKey: .replies)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(post, forKey: .post)
        try container.encodeIfPresent(replies, forKey: .replies)
    }
}
