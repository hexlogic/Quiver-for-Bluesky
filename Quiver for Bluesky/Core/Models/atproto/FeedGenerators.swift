struct FeedGeneratorsModel: Codable {
    let feeds: [FeedGeneratorModel]
    let cursor: String
}

// MARK: - Feed Generator
struct FeedGeneratorModel: Codable {
    let uri: String
    let cid: String
    let did: String
    let creator: CreatorModel
    let displayName: String
    let description: String
    let avatar: String?
    let likeCount: Int
    let labels: [LabelModel]
    let indexedAt: String
}

// MARK: - Creator
struct CreatorModel: Codable {
    let did: String
    let handle: String
    let displayName: String
    let avatar: String
    let associated: AssociatedModel?
    let labels: [LabelModel]
    let createdAt: String
    let description: String
    let indexedAt: String
}
