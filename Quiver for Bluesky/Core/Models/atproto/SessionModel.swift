import Foundation

struct SessionModel: Codable, Equatable {
    let did: String?
    let didDoc: DidDocModel?
    let handle: String?
    let email: String?
    let emailConfirmed: Bool?
    let emailAuthFactor: Bool?
    let accessJwt: String?
    let refreshJwt: String?
    let active: Bool?
    
    static func == (lhs: SessionModel, rhs: SessionModel) -> Bool {
        lhs.did == rhs.did
        && lhs.handle == rhs.handle
        && lhs.email == rhs.email
        && lhs.emailConfirmed == rhs.emailConfirmed
        && lhs.emailAuthFactor == rhs.emailAuthFactor
        && lhs.accessJwt == rhs.accessJwt
        && lhs.refreshJwt == rhs.refreshJwt
    }
    
    enum CodingKeys: String, CodingKey {
        case did
        case didDoc
        case handle
        case email
        case emailConfirmed
        case emailAuthFactor
        case accessJwt
        case refreshJwt
        case active
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.did = try container.decodeIfPresent(String.self, forKey: .did)
        self.didDoc = try container.decodeIfPresent(DidDocModel.self, forKey: .didDoc)
        self.handle = try container.decodeIfPresent(String.self, forKey: .handle)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.emailConfirmed = try container.decodeIfPresent(Bool.self, forKey: .emailConfirmed)
        self.emailAuthFactor = try container.decodeIfPresent(Bool.self, forKey: .emailAuthFactor)
        self.accessJwt = try container.decodeIfPresent(String.self, forKey: .accessJwt)
        self.refreshJwt = try container.decodeIfPresent(String.self, forKey: .refreshJwt)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(did, forKey: .did)
        try container.encodeIfPresent(didDoc, forKey: .didDoc)
        try container.encodeIfPresent(handle, forKey: .handle)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(emailConfirmed, forKey: .emailConfirmed)
        try container.encodeIfPresent(emailAuthFactor, forKey: .emailAuthFactor)
        try container.encodeIfPresent(accessJwt, forKey: .accessJwt)
        try container.encodeIfPresent(refreshJwt, forKey: .refreshJwt)
        try container.encodeIfPresent(active, forKey: .active)
    }
}

struct DidDocModel: Codable {
    let context: [String]?
    let id: String?
    let alsoKnownAs: [String]?
    let verificationMethod: [VerificationMethodModel]?
    let service: [ServiceModel]?
    
    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id
        case alsoKnownAs
        case verificationMethod
        case service
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.context = try container.decodeIfPresent([String].self, forKey: .context)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.alsoKnownAs = try container.decodeIfPresent([String].self, forKey: .alsoKnownAs)
        self.verificationMethod = try container.decodeIfPresent([VerificationMethodModel].self, forKey: .verificationMethod)
        self.service = try container.decodeIfPresent([ServiceModel].self, forKey: .service)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(context, forKey: .context)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(alsoKnownAs, forKey: .alsoKnownAs)
        try container.encodeIfPresent(verificationMethod, forKey: .verificationMethod)
        try container.encodeIfPresent(service, forKey: .service)
    }
}

struct VerificationMethodModel: Codable {
    let id: String?
    let type: String?
    let controller: String?
    let publicKeyMultibase: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case controller
        case publicKeyMultibase
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.controller = try container.decodeIfPresent(String.self, forKey: .controller)
        self.publicKeyMultibase = try container.decodeIfPresent(String.self, forKey: .publicKeyMultibase)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(controller, forKey: .controller)
        try container.encode(publicKeyMultibase, forKey: .publicKeyMultibase)
    }
}

struct ServiceModel: Codable {
    let id: String?
    let type: String?
    let serviceEndpoint: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case serviceEndpoint
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.serviceEndpoint = try container.decodeIfPresent(String.self, forKey: .serviceEndpoint)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(serviceEndpoint, forKey: .serviceEndpoint)
    }
}
