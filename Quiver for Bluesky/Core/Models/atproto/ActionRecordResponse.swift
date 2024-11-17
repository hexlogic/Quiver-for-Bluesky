struct ActionRecordResponseModel: Codable {
    let cid: String?
    let commit: ActionCommitModel?
    let uri: String?
    let validationStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case cid
        case commit
        case uri
        case validationStatus
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.commit = try container.decodeIfPresent(ActionCommitModel.self, forKey: .commit)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
        self.validationStatus = try container.decodeIfPresent(String.self, forKey: .validationStatus)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cid, forKey: .cid)
        try container.encodeIfPresent(commit, forKey: .commit)
        try container.encodeIfPresent(uri, forKey: .uri)
        try container.encodeIfPresent(validationStatus, forKey: .validationStatus)
    }
}

struct ActionCommitModel: Codable {
    let cid: String?
    let rev: String?
    
    enum CodingKeys: String, CodingKey {
        case cid
        case rev
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.rev = try container.decodeIfPresent(String.self, forKey: .rev)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cid, forKey: .cid)
        try container.encodeIfPresent(rev, forKey: .rev)
    }
}
