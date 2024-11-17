struct ErrorResponse: Decodable {
    let error: String?
    let message: String?
    let statusCode: Int?
    let errorType: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case statusCode = "status"
        case errorType = "type"
    }
}
