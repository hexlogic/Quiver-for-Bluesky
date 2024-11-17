struct DeleteActionRecordDTO: Codable {
    let collection: ActionType
    let repo: String
    let rkey: String
    
    enum CodingKeys: String, CodingKey {
        case collection, repo, rkey
    }
    
    init(collection: ActionType, repo: String, rkey: String) {
        self.collection = collection
        self.repo = repo
        self.rkey = rkey
    }
}
