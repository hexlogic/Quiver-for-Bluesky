struct BlueskyProfileModel: Codable {
    let did: String?
    let handle: String?
    let displayName: String?
    let avatar: String?
    let associated: Associated?
    let viewer: Viewer?
    let labels: [String]?
    let createdAt: String?
    let description: String?
    let indexedAt: String?
    let banner: String?
    let followersCount: Int?
    let followsCount: Int?
    let postsCount: Int?
    let pinnedPost: PinnedPost?
    
    enum CodingKeys: String, CodingKey {
        case did
        case handle
        case displayName
        case avatar
        case associated
        case viewer
        case labels
        case createdAt
        case description
        case indexedAt
        case banner
        case followersCount
        case followsCount
        case postsCount
        case pinnedPost
    }
    
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.did, forKey: .did)
        try container.encodeIfPresent(self.handle, forKey: .handle)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.associated, forKey: .associated)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.banner, forKey: .banner)
        try container.encodeIfPresent(self.followersCount, forKey: .followersCount)
        try container.encodeIfPresent(self.followsCount, forKey: .followsCount)
        try container.encodeIfPresent(self.postsCount, forKey: .postsCount)
        try container.encodeIfPresent(self.pinnedPost, forKey: .pinnedPost)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.did = try container.decodeIfPresent(String.self, forKey: .did)
        self.handle = try container.decodeIfPresent(String.self, forKey: .handle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.associated = try container.decodeIfPresent(BlueskyProfileModel.Associated.self, forKey: .associated)
        self.viewer = try container.decodeIfPresent(BlueskyProfileModel.Viewer.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([String].self, forKey: .labels)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.indexedAt = try container.decodeIfPresent(String.self, forKey: .indexedAt)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.followsCount = try container.decodeIfPresent(Int.self, forKey: .followsCount)
        self.postsCount = try container.decodeIfPresent(Int.self, forKey: .postsCount)
        self.pinnedPost = try container.decodeIfPresent(BlueskyProfileModel.PinnedPost.self, forKey: .pinnedPost)
    }
    
    struct Associated: Codable {
        let lists: Int?
        let feedgens: Int?
        let starterPacks: Int?
        let labeler: Bool?
        let chat: Chat?
        
        enum CodingKeys: String, CodingKey {
            case lists
            case feedgens
            case starterPacks
            case labeler
            case chat
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<BlueskyProfileModel.Associated.CodingKeys> = try decoder.container(keyedBy: BlueskyProfileModel.Associated.CodingKeys.self)
            self.lists = try container.decodeIfPresent(Int.self, forKey: BlueskyProfileModel.Associated.CodingKeys.lists)
            self.feedgens = try container.decodeIfPresent(Int.self, forKey: BlueskyProfileModel.Associated.CodingKeys.feedgens)
            self.starterPacks = try container.decodeIfPresent(Int.self, forKey: BlueskyProfileModel.Associated.CodingKeys.starterPacks)
            self.labeler = try container.decodeIfPresent(Bool.self, forKey: BlueskyProfileModel.Associated.CodingKeys.labeler)
            self.chat = try container.decodeIfPresent(BlueskyProfileModel.Associated.Chat.self, forKey: BlueskyProfileModel.Associated.CodingKeys.chat)
        }
        
        func encode(to encoder: Encoder) throws {
            var container: KeyedEncodingContainer<BlueskyProfileModel.Associated.CodingKeys> = encoder.container(keyedBy: BlueskyProfileModel.Associated.CodingKeys.self)
            try container.encodeIfPresent(lists, forKey: BlueskyProfileModel.Associated.CodingKeys.lists)
            try container.encodeIfPresent(feedgens, forKey: BlueskyProfileModel.Associated.CodingKeys.feedgens)
            try container.encodeIfPresent(starterPacks, forKey: BlueskyProfileModel.Associated.CodingKeys.starterPacks)
            try container.encodeIfPresent(chat, forKey: BlueskyProfileModel.Associated.CodingKeys.chat)
            try container.encodeIfPresent(labeler, forKey: BlueskyProfileModel.Associated.CodingKeys.labeler)
        }
        
        struct Chat: Codable {
            let allowIncoming: String?
            
            private enum CodingKeys: String, CodingKey {
                case allowIncoming = "allowIncoming"
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<BlueskyProfileModel.Associated.Chat.CodingKeys> = try decoder.container(keyedBy: BlueskyProfileModel.Associated.Chat.CodingKeys.self)
                self.allowIncoming = try container.decodeIfPresent(String.self, forKey: BlueskyProfileModel.Associated.Chat.CodingKeys.allowIncoming)
            }
            
            func encode(to encoder: Encoder) throws {
                var container: KeyedEncodingContainer<BlueskyProfileModel.Associated.Chat.CodingKeys> = encoder.container(keyedBy: BlueskyProfileModel.Associated.Chat.CodingKeys.self)
                try container.encodeIfPresent(allowIncoming, forKey: BlueskyProfileModel.Associated.Chat.CodingKeys.allowIncoming)
            }
        }
    }
    
    struct Viewer: Codable {
        let muted: Bool?
        let blockedBy: Bool?
        
        enum CodingKeys: String, CodingKey {
            case muted, blockedBy
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<BlueskyProfileModel.Viewer.CodingKeys> = try decoder.container(keyedBy: BlueskyProfileModel.Viewer.CodingKeys.self)
            self.muted = try container.decodeIfPresent(Bool.self, forKey: BlueskyProfileModel.Viewer.CodingKeys.muted)
            self.blockedBy = try container.decodeIfPresent(Bool.self, forKey: BlueskyProfileModel.Viewer.CodingKeys.blockedBy)
        }
        
        func encode(to encoder: any Encoder) throws {
            var container: KeyedEncodingContainer<BlueskyProfileModel.Viewer.CodingKeys> = encoder.container(keyedBy: BlueskyProfileModel.Viewer.CodingKeys.self)
            try container.encodeIfPresent(muted, forKey: BlueskyProfileModel.Viewer.CodingKeys.muted)
            try container.encodeIfPresent(blockedBy, forKey: BlueskyProfileModel.Viewer.CodingKeys.blockedBy)
        }
    }
    
    struct PinnedPost: Codable {
        let cid: String?
        let uri: String?
        
        enum CodingKeys: String, CodingKey {
            case cid, uri
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<BlueskyProfileModel.PinnedPost.CodingKeys> = try decoder.container(keyedBy: BlueskyProfileModel.PinnedPost.CodingKeys.self)
            self.cid = try container.decodeIfPresent(String.self, forKey: BlueskyProfileModel.PinnedPost.CodingKeys.cid)
            self.uri = try container.decodeIfPresent(String.self, forKey: BlueskyProfileModel.PinnedPost.CodingKeys.uri)
        }
        
        func encode(to encoder: any Encoder) throws {
            var container: KeyedEncodingContainer<BlueskyProfileModel.PinnedPost.CodingKeys> = encoder.container(keyedBy: BlueskyProfileModel.PinnedPost.CodingKeys.self)
            try container.encodeIfPresent(cid, forKey: BlueskyProfileModel.PinnedPost.CodingKeys.cid)
            try container.encodeIfPresent(uri, forKey: BlueskyProfileModel.PinnedPost.CodingKeys.uri)
        }
    }
}
