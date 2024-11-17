// MARK: - Feed Response

import Foundation

struct PostsResponseModel: Codable {
    let posts: [PostModel]?
}

struct FeedResponseModel: Codable {
    let feed: [FeedItemModel]?
    let cursor: String?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(feed, forKey: .feed)
        try container.encode(cursor, forKey: .cursor)
    }
    
    enum CodingKeys: CodingKey {
        case feed
        case cursor
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.feed = try container.decodeIfPresent([FeedItemModel].self, forKey: .feed) ?? []
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
    }
}

struct FeedItemReplyModel: Codable {
    let parent: PostModel?
    let root: PostModel?
}

// MARK: - Feed Item
struct FeedItemModel: Codable, Identifiable, Equatable {
    static func == (lhs: FeedItemModel, rhs: FeedItemModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
    
    let post: PostModel?
    let reason: ReasonModel?
    let feedContext: String?
    let reply: FeedItemReplyModel?
    
    
    enum CodingKeys: String, CodingKey {
        case post
        case feedContext
        case reason
        case reply
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(post, forKey: .post)
        try container.encode(feedContext, forKey: .feedContext)
        try container.encode(reason, forKey: .reason)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post = try container.decodeIfPresent(PostModel.self, forKey: .post)
        self.feedContext = try container.decodeIfPresent(String.self, forKey: .feedContext)
        self.reason = try container.decodeIfPresent(ReasonModel.self, forKey: .reason)
        self.reply = try container.decodeIfPresent(FeedItemReplyModel.self, forKey: .reply)
    }
}

struct ReasonModel: Codable {
    let type: String
    let by: AuthorModel?
    let indexedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case by
        case indexedAt
    }
}

// MARK: - Post
struct PostModel: Codable {
    let uri: String?
    let cid: String?
    let author: AuthorModel?
    let record: RecordModel?
    let embed: EmbedModel?
    let replyCount: Int?
    let repostCount: Int?
    let likeCount: Int?
    let quoteCount: Int?
    let indexedAt: String?
    let labels: [LabelModel]?
    let threadgate: ThreadgateModel?
    let viewer: ViewerModel?
    
    enum CodingKeys: String, CodingKey {
        case uri
        case cid
        case author
        case record
        case embed
        case replyCount
        case repostCount
        case likeCount
        case quoteCount
        case indexedAt
        case labels
        case threadgate
        case viewer
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(cid, forKey: .cid)
        try container.encode(author, forKey: .author)
        try container.encode(record, forKey: .record)
        try container.encode(embed, forKey: .embed)
        try container.encode(replyCount, forKey: .replyCount)
        try container.encode(repostCount, forKey: .repostCount)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(quoteCount, forKey: .quoteCount)
        try container.encode(indexedAt, forKey: .indexedAt)
        try container.encode(labels, forKey: .labels)
        try container.encode(threadgate, forKey: .threadgate)
        try container.encode(viewer, forKey: .viewer)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.author = try container.decodeIfPresent(AuthorModel.self, forKey: .author)
        self.record = try container.decodeIfPresent(RecordModel.self, forKey: .record)
        self.embed  = try container.decodeIfPresent(EmbedModel.self, forKey: .embed)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.quoteCount = try container.decodeIfPresent(Int.self, forKey: .quoteCount)
        self.indexedAt = try container.decodeIfPresent(String.self, forKey: .indexedAt)
        self.labels = try container.decodeIfPresent([LabelModel].self, forKey: .labels)
        self.threadgate = try container.decodeIfPresent(ThreadgateModel.self, forKey: .threadgate)
        self.viewer = try container.decodeIfPresent(ViewerModel.self, forKey: .viewer)
    }
}

struct ViewerModel: Codable {
    let repost: String?
    let like: String?
    let threadMuted: Bool?
    let replyDisabled: Bool?
    let pinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case repost, like, threadMuted, replyDisabled, pinned
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.repost = try container.decodeIfPresent(String.self, forKey: .repost)
        self.like = try container.decodeIfPresent(String.self, forKey: .like)
        self.threadMuted = try container.decodeIfPresent(Bool.self, forKey: .threadMuted)
        self.replyDisabled = try container.decodeIfPresent(Bool.self, forKey: .replyDisabled)
        self.pinned = try container.decodeIfPresent(Bool.self, forKey: .pinned)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(repost, forKey: .repost)
        try container.encode(like, forKey: .like)
        try container.encode(threadMuted, forKey: .threadMuted)
        try container.encode(replyDisabled, forKey: .replyDisabled)
        try container.encode(pinned, forKey: .pinned)
    }
}

// MARK: - Author
struct AuthorModel: Codable {
    let did: String?
    let handle: String?
    let displayName: String?
    let avatar: String?
    let associated: AssociatedModel?
    let labels: [LabelModel]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case did, handle, displayName, avatar, associated, labels, createdAt
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(did, forKey: .did)
        try container.encode(handle, forKey: .handle)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(associated, forKey: .associated)
        try container.encode(labels, forKey: .labels)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.did = try container.decodeIfPresent(String.self, forKey: .did)
        self.handle = try container.decodeIfPresent(String.self, forKey: .handle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.associated = try container.decodeIfPresent(AssociatedModel.self, forKey: .associated)
        self.labels = try container.decodeIfPresent([LabelModel].self, forKey: .labels)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

// MARK: - Associated
struct AssociatedModel: Codable {
    let chat: ChatModel?
    
    enum CodingKeys: String, CodingKey {
        case chat
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chat, forKey: .chat)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chat = try container.decodeIfPresent(ChatModel.self, forKey: .chat)
    }
}

// MARK: - Chat
struct ChatModel: Codable {
    let allowIncoming: String?
    
    enum CodingKeys: String, CodingKey {
        case allowIncoming
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allowIncoming, forKey: .allowIncoming)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.allowIncoming = try container.decodeIfPresent(String.self, forKey: .allowIncoming)
    }
}

// MARK: - Label
struct LabelModel: Codable {
    let src: String?
    let uri: String?
    let cid: String?
    let val: String?
    let cts: String?
    let ver: Int?
    
    enum CodingKeys: String, CodingKey {
        case src, uri, cid, val, cts, ver
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(src, forKey: .src)
        try container.encode(uri, forKey: .uri)
        try container.encode(cid, forKey: .cid)
        try container.encode(val, forKey: .val)
        try container.encode(cts, forKey: .cts)
        try container.encode(ver, forKey: .ver)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.src = try container.decodeIfPresent(String.self, forKey: .src)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.val = try container.decodeIfPresent(String.self, forKey: .val)
        self.cts = try container.decodeIfPresent(String.self, forKey: .cts)
        self.ver = try container.decodeIfPresent(Int.self, forKey: .ver)
    }
}

// MARK: - Record
struct RecordModel: Codable {
    let type: String?
    let createdAt: String?
    let text: String?
    let embed: RecordEmbedModel?
    let facets: [FacetModel]?
    let langs: [String]?
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case createdAt, text, embed, facets, langs, tags
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(text, forKey: .text)
        try container.encode(embed, forKey: .embed)
        try container.encode(facets, forKey: .facets)
        try container.encode(langs, forKey: .langs)
        try container.encode(tags, forKey: .tags)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.embed = try container.decodeIfPresent(RecordEmbedModel.self, forKey: .embed)
        self.facets = try container.decodeIfPresent([FacetModel].self, forKey: .facets)
        self.langs = try container.decodeIfPresent([String].self, forKey: .langs)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
    }
}

// MARK: - Embed
struct EmbedModel: Codable {
    let type: String?
    let external: ExternalModel?
    let externalBSViewModel: ExternalBSViewModel?
    let images: [EmbedImageModel]?
    let record: EmbedRecordModel?
    let playlist: String?
    let aspectRatio: AspectRatioModel?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external, images, record, playlist, aspectRatio
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        
        self.images = try container.decodeIfPresent([EmbedImageModel].self, forKey: .images)
        self.record = try container.decodeIfPresent(EmbedRecordModel.self, forKey: .record)
        self.playlist = try container.decodeIfPresent(String.self, forKey: .playlist)
        self.aspectRatio = try container.decodeIfPresent(AspectRatioModel.self, forKey: .aspectRatio)
        if(self.type == "app.bsky.embed.external") {
            self.external = try container.decodeIfPresent(ExternalModel.self, forKey: .external)
            self.externalBSViewModel = nil
        }
        else if(self.type == "app.bsky.embed.external#view") {
            self.externalBSViewModel = try container.decodeIfPresent(ExternalBSViewModel.self, forKey: .external)
            self.external = nil
        } else {
            self.external = nil
            self.externalBSViewModel = nil
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(external, forKey: .external)
        try container.encode(images, forKey: .images)
        try container.encode(record, forKey: .record)
        try container.encode(playlist, forKey: .playlist)
        try container.encode(aspectRatio, forKey: .aspectRatio)
    }
}

// MARK: - External
struct ExternalModel: Codable {
    let uri: String?
    let title: String?
    let description: String?
    let thumb: ImageDataModel?
    
    enum CodingKeys: String, CodingKey {
        case uri, title, description, thumb
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumb = try container.decodeIfPresent(ImageDataModel.self, forKey: .thumb)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(thumb, forKey: .thumb)
    }
}

// MARK: - External
struct ExternalBSViewModel: Codable {
    let uri: String?
    let title: String?
    let description: String?
    let thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case uri, title, description, thumb
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(thumb, forKey: .thumb)
    }
}

// MARK: - EmbedImage
struct EmbedImageModel: Codable, Identifiable, Hashable {
    static func == (lhs: EmbedImageModel, rhs: EmbedImageModel) -> Bool {
        lhs.alt == rhs.alt
        && lhs.fullsize == rhs.fullsize
        && lhs.id == rhs.id
        && lhs.thumb == rhs.thumb
    }
    
    let thumb: String?
    let fullsize: String?
    let alt: String?
    let aspectRatio: AspectRatioModel?
    let id: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case thumb, fullsize, alt, aspectRatio
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
        self.fullsize = try container.decodeIfPresent(String.self, forKey: .fullsize)
        self.alt = try container.decodeIfPresent(String.self, forKey: .alt)
        self.aspectRatio = try container.decodeIfPresent(AspectRatioModel.self, forKey: .aspectRatio)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(thumb, forKey: .thumb)
        try container.encode(fullsize, forKey: .fullsize)
        try container.encode(alt, forKey: .alt)
        try container.encode(aspectRatio, forKey: .aspectRatio)
    }
}

// MARK: - AspectRatio
struct AspectRatioModel: Codable, Hashable {
    let height: Int?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case height, width
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
    }
}

// MARK: - EmbedRecord
struct EmbedRecordModel: Codable {
    let cid: String?
    let uri: String?
    let author: AuthorModel?
    let indexedAt: String?
    let likeCount: Int?
    let quoteCount: Int?
    let replyCount: Int?
    let repostCount: Int?
    let value: PostEmbedValue?
    let type: String?
    let creator: AuthorModel?
    let avatar: String?
    let name: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case cid
        case uri
        case author
        case indexedAt
        case likeCount
        case quoteCount
        case replyCount
        case repostCount
        case value
        case type = "$type"
        case creator
        case avatar
        case name
        case description
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.author = try container.decodeIfPresent(AuthorModel.self, forKey: .author)
        self.indexedAt = try container.decodeIfPresent(String.self, forKey: .indexedAt)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.quoteCount = try container.decodeIfPresent(Int.self, forKey: .quoteCount)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.value = try container.decodeIfPresent(PostEmbedValue.self, forKey: .value)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.creator = try container.decodeIfPresent(AuthorModel.self, forKey: .creator)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cid, forKey: .cid)
        try container.encode(uri, forKey: .uri)
        try container.encode(author, forKey: .author)
        try container.encode(indexedAt, forKey: .indexedAt)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(quoteCount, forKey: .quoteCount)
        try container.encode(replyCount, forKey: .replyCount)
        try container.encode(repostCount, forKey: .repostCount)
        try container.encode(value, forKey: .value)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(creator, forKey: .creator)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
    }
}

struct PostEmbedValue: Codable {
    let type: String?
    var createdAt: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case createdAt
        case text
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(text, forKey: .text)
    }
}

// MARK: - RecordEmbed
struct RecordEmbedModel: Codable {
    let type: String?
    let external: ExternalModel?
    let images: [ImageInfoModel]?
    let video: VideoModel?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external, images, video
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.external = try container.decodeIfPresent(ExternalModel.self, forKey: .external)
        self.images = try container.decodeIfPresent([ImageInfoModel].self, forKey: .images)
        self.video = try container.decodeIfPresent(VideoModel.self, forKey: .video)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(external, forKey: .external)
        try container.encode(images, forKey: .images)
        try container.encode(video, forKey: .video)
    }
}

// MARK: - ImageInfo
struct ImageInfoModel: Codable {
    let alt: String?
    let image: ImageDataModel?
    let aspectRatio: AspectRatioModel?
    
    enum CodingKeys: String, CodingKey {
        case alt, image, aspectRatio
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alt = try container.decodeIfPresent(String.self, forKey: .alt)
        self.image = try container.decodeIfPresent(ImageDataModel.self, forKey: .image)
        self.aspectRatio = try container.decodeIfPresent(AspectRatioModel.self, forKey: .aspectRatio)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alt, forKey: .alt)
        try container.encode(image, forKey: .image)
        try container.encode(aspectRatio, forKey: .aspectRatio)
    }
}

// MARK: - ImageData
struct ImageDataModel: Codable {
    let type: String?
    let ref: ReferenceModel?
    let mimeType: String?
    let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case ref, mimeType, size
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.ref = try container.decodeIfPresent(ReferenceModel.self, forKey: .ref)
        self.mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType)
        self.size = try container.decodeIfPresent(Int.self, forKey: .size)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(ref, forKey: .ref)
        try container.encode(mimeType, forKey: .mimeType)
        try container.encode(size, forKey: .size)
    }
}

// MARK: - Reference
struct ReferenceModel: Codable {
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(link, forKey: .link)
    }
}

// MARK: - Video
struct VideoModel: Codable {
    let type: String?
    let ref: ReferenceModel?
    let mimeType: String?
    let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case ref, mimeType, size
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.ref = try container.decodeIfPresent(ReferenceModel.self, forKey: .ref)
        self.mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType)
        self.size = try container.decodeIfPresent(Int.self, forKey: .size)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(ref, forKey: .ref)
        try container.encode(mimeType, forKey: .mimeType)
        try container.encode(size, forKey: .size)
    }
}

// MARK: - Facet
struct FacetModel: Codable {
    let features: [FeatureModel]?
    let index: IndexModel?
    
    enum CodingKeys: String, CodingKey {
        case features, index
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.features = try container.decodeIfPresent([FeatureModel].self, forKey: .features)
        self.index = try container.decodeIfPresent(IndexModel.self, forKey: .index)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(features, forKey: .features)
        try container.encode(index, forKey: .index)
    }
}

// MARK: - Feature
struct FeatureModel: Codable {
    let type: String?
    let tag: String?
    let uri: String?
    let did: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case tag, uri, did
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.tag = try container.decodeIfPresent(String.self, forKey: .tag)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.did = try container.decodeIfPresent(String.self, forKey: .did)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(tag, forKey: .tag)
        try container.encode(uri, forKey: .uri)
        try container.encode(did, forKey: .did)
    }
}

// MARK: - Index
struct IndexModel: Codable {
    let byteEnd: Int?
    let byteStart: Int?
    
    enum CodingKeys: String, CodingKey {
        case byteEnd, byteStart
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.byteEnd = try container.decodeIfPresent(Int.self, forKey: .byteEnd)
        self.byteStart = try container.decodeIfPresent(Int.self, forKey: .byteStart)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(byteEnd, forKey: .byteEnd)
        try container.encode(byteStart, forKey: .byteStart)
    }
}

// MARK: - Threadgate
struct ThreadgateModel: Codable {
    let uri: String?
    let cid: String?
    let record: ThreadgateRecordModel?
    let lists: [String]?
    
    enum CodingKeys: String, CodingKey {
        case uri, cid, record, lists
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.record = try container.decodeIfPresent(ThreadgateRecordModel.self, forKey: .record)
        self.lists = try container.decodeIfPresent([String].self, forKey: .lists)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(cid, forKey: .cid)
        try container.encode(record, forKey: .record)
    }
}

// MARK: - ThreadgateRecord
struct ThreadgateRecordModel: Codable {
    let type: String?
    let createdAt: String?
    let post: String?
    let hiddenReplies: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case createdAt, post, hiddenReplies
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.post = try container.decodeIfPresent(String.self, forKey: .post)
        self.hiddenReplies = try container.decodeIfPresent([String].self, forKey: .hiddenReplies)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(post, forKey: .post)
    }
}
